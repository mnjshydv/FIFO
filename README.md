**Overview**
This project implements a synchronous FIFO (First-In-First-Out) buffer in SystemVerilog. The FIFO is designed to operate in a single clock domain, supporting simultaneous read and write operations when the buffer is neither full nor empty. It uses a dual-port RAM for data storage, instantiated in the top.sv module, with separate modules for FIFO control logic and memory.

**Modules**
fifo.sv (Sync_FIFO)  
Implements FIFO control logic:

Write and read pointers (waddr, raddr)

Push/Pop control signals (we, re)

Full, empty, almost full, and almost empty flags

Data forwarding to RAM (wr_data)

ram.sv  
Implements synchronous dual-port RAM:

Write enable and read enable signals

Separate read and write addresses

Stores FIFO data entries

top.sv  
Integrates FIFO and RAM:

Instantiates Sync_FIFO for control logic

Instantiates ram for data storage

Connects FIFO outputs (we, re, waddr, raddr, wr_data) to RAM inputs

tb.sv (Testbench)  
Provides simulation environment:

Generates clock and reset

Applies push and pop operations

Verifies data integrity by comparing input and output

Prints FIFO status (addresses, flags, data) during simulation

**Features**
Parameterized design (ADDR_WIDTH, DEPTH, WIDTH) for flexibility

Proper handling of full/empty conditions

Almost full/empty flags for early warning

Supports simultaneous read/write in the same cycle

Self-checking testbench for functional verification
