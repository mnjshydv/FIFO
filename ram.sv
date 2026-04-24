`timescale 1ns / 1ps
module ram#(
  parameter ADDR_WIDTH = 4,
  parameter DEPTH = 16,
  parameter WIDTH = 8
)(
  input logic clock,
  input logic resetn,
  input logic we,
  input logic re,
  input logic [ADDR_WIDTH-1:0]waddr,
  input logic [ADDR_WIDTH-1:0]raddr,
  input logic [WIDTH-1:0]wr_data,
  output logic [WIDTH-1:0]rd_data
);
  logic [WIDTH-1:0] MEM [0:DEPTH-1];
  
  //write logic
  always_ff@(posedge clock)
    begin
      if(!resetn)
        for(int i=0;i<DEPTH;i++)
          MEM[i] <= {WIDTH{1'b0}};
      else if(we)
        MEM[waddr] <= wr_data;
    end
    
  //read logic 
  always_ff@(posedge clock)
    begin
      if(!resetn)
        rd_data <= {WIDTH{1'b0}};
      else if(re)
        rd_data <= MEM[raddr];
    end
endmodule

