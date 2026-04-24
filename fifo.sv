`timescale 1ns / 1ps
module fifo#(
  parameter ADDR_WIDTH = 4,
  parameter DEPTH = 16,
  parameter WIDTH = 8
)(
  input logic clock,
  input logic resetn,
  input logic push,
  input logic [WIDTH-1:0]din,
  input logic pop,
  output logic full,
  output logic almost_full,
  output logic empty,
  output logic almost_empty,
  output logic we,
  output logic re,
  output logic [ADDR_WIDTH:0]waddr,
  output logic [ADDR_WIDTH:0]raddr,
  output logic [WIDTH-1:0]wr_data
  );  
  localparam ALMOSTFULL_DEPTH = DEPTH - 3;
  localparam ALMOSTEMPTY_DEPTH = 3;
  
  logic [ADDR_WIDTH:0] occupancy;

  always_comb begin
    if (waddr >= raddr)
      occupancy = waddr - raddr;
    else
      occupancy = (DEPTH + waddr) - raddr; // wrap-around case
  end

  // Write pointer
  always_ff @(posedge clock) begin
    if(!resetn)
      waddr <= 0;
    else if(push && !full)
      waddr <= waddr + 1;
  end

  // Read pointer
  always_ff @(posedge clock) begin
    if(!resetn)
      raddr <= 0;
    else if(pop && !empty)
      raddr <= raddr + 1;
  end
    
  //we, re logic
  assign re = (pop && !empty) ? 1'b1 : 1'b0;
  assign we = (push && !full) ? 1'b1 : 1'b0;  
  
  //wr_data logic
  assign wr_data = din;
   
  //full and empty logic
  assign almost_full  = (occupancy >= ALMOSTFULL_DEPTH);
  assign almost_empty = (occupancy <= ALMOSTEMPTY_DEPTH);
  assign full = ((waddr[4] != raddr[4]) && (waddr[3:0] == raddr[3:0])) ? 1'b1 : 1'b0;
  assign empty = (raddr == waddr) ? 1'b1 :1'b0;
endmodule 

