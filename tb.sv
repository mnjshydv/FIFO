`timescale 1ns/1ps
module tb_top;

  // Parameters
  parameter ADDR_WIDTH = 4;
  parameter DEPTH      = 16;
  parameter WIDTH      = 8;

  // DUT signals
  logic clock;
  logic resetn;
  logic push;
  logic pop;
  logic [WIDTH-1:0] din;
  logic [WIDTH-1:0] dout;
  logic full, almost_full, empty, almost_empty;

  // Instantiate DUT
  top #(ADDR_WIDTH, DEPTH, WIDTH) dut (
    .clock(clock),
    .resetn(resetn),
    .push(push),
    .din(din),
    .pop(pop),
    .dout(dout),
    .full(full),
    .almost_full(almost_full),
    .empty(empty),
    .almost_empty(almost_empty)
  );

  // Clock generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock; // 100 MHz
  end
  
  task initialization;
    resetn= 0;
    {push,din,pop} = 0;
  endtask
  
  task RESET;
    @(negedge clock);
    resetn = 0;
    @(negedge clock);
    resetn = 1;
  endtask

  task push_pop;
    @(negedge clock);
    push = 1'd1;
    din = 8'd10;
    @(negedge clock);
    push = 1'd0;
    pop = 1'd1;
    @(negedge clock);
    pop = 1'd0;
    push = 1'd0;
    @(negedge clock);
  endtask
  
  //FULL condition
  task stimulus_full;
    for(int i=0;i<20;i++)
      begin
      @(negedge clock);
      push = 1;
      din = $random % 128;
      if(full)   
        $display("FIFO is full");
      end
      push = 1'd0;
  endtask
  
  //EMPTY condition
  task stimulus_empty;
    for(int i=0;i<20;i++)
      begin
        @(negedge clock)
        pop = 1'd1;
        $display("dout = %0d",dout);
        if(empty)        
          $display("FIFO is empty");
      end
    pop = 1'd0;
  endtask
  
  task stimulus;
    repeat(20)
      begin
        @(negedge clock);
        push = 1'b1;
        pop = 1'b1;
        din = $random;
      end
  endtask  
           
  initial 
    begin
      initialization;
      RESET;
      push_pop;
      stimulus_full;
      stimulus_empty;
      stimulus;
      repeat(5)
        @(negedge clock);
      $finish;
    end
    
  initial 
    begin
      $monitor($time,"push =%0b, pop = %0b, din = %0b, dout = %0b",push,pop,din,dout);
    end
    

endmodule


