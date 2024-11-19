// Semaphores and mailbox are itself a parameterized class

// Assuming we have a data source where multiple classes are trying to add data

// Semaphore is used when multiple classes wants to add data

// Sharing interface between classes get and put methods.

// Accesses resources of tb top

class first;

  rand int data;
  constraint data_c {data<10;data>0;}

endclass


class second;

  rand int data;
  constraint data_c{data>10;data<20;}

endclass


//declare the semaphore in main class and giving access to all the variables

class main;

  semaphore sem; // creating semaphore variable

  first f;
  second s;

  // Agenda: Both Classes will be going to write into this data member
  int data;
  int i = 0;
  

  // This task will allow class first to write data member to variables



  task send_first();
    // Get semaphore access
    // When one is added we have one semaphore
    // basically this 1 describes the id of the semaphore to access
    sem.get(1); // These can be multiple semaphore but it will be hard to access so we are currently handling only one

    for(i=0;i<10;i++) begin
      f.randomize();
      data = f.data;
      $display("First access Semaphore and Da");
    end

    // Here we are making semaphore free
    sem.put(1);
    $display("Semaphore Unoccupied");
  endtask

  task send_second();

    // Getting acces of semaphore
    sem.get(1);

    // writing 10 random transactions to our data source
    for(i=0;i<10;i++) begin
      s.randomize();
      data = s.data;
      $display("Second access Semaphore and Data sent: %0d",s.data);
      #10;
    end

    // releasing our semaphore
    sem.put(1);
  endtask

  task run();
    sem = new(1); // We have a single semaphore which can be accessed by a single class
    f = new();
    s = new();

    fork

      send_first(); // Since we are using get method in semaphore so until first executes second will wait
      send_second();

    join

  endtask

endclass


module tb;

  main m;
  
  initial begin
    m = new();  // creating object for main class
    m.run();  // Executing task run
  end

endmodule
