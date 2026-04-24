`timescale 1ns / 1ps
module top#(
  parameter ADDR_WIDTH = 4,
  parameter DEPTH = 16,
  parameter WIDTH = 8
)(
  input logic clock,
  input logic resetn,
  input logic push,
  input logic [WIDTH-1:0]din,
  input logic pop,
  output logic [WIDTH-1:0]dout,
  output logic full,
  output logic almost_full,
  output logic empty,
  output logic almost_empty);
  
  logic  we;
  logic re;
  logic [ADDR_WIDTH-1:0]waddr;
  logic [ADDR_WIDTH-1:0]raddr;
  logic [WIDTH-1:0]wr_data;
  
  fifo      #(ADDR_WIDTH,DEPTH,WIDTH) FIFO
             (.clock(clock),
	      .resetn(resetn),
              .push(push),                  
              .din(din),
              .pop(pop),
              .full(full),
              .almost_full(almost_full),
              .empty(empty),
              .almost_empty(almost_empty),
              .we(we),
              .re(re),
              .waddr(waddr),
              .raddr(raddr),
              .wr_data(wr_data));
  
  ram #(ADDR_WIDTH,DEPTH,WIDTH) RAM
       (.clock(clock),
	.resetn(resetn),
        .we(we),
        .re(re),
        .waddr(waddr),
        .raddr(raddr),
        .wr_data(wr_data),
        .rd_data(dout));

endmodule

