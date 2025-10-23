module Modular_LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

// Header Module: Manages stack pointer (SP)
reg [BUFFER_SIZE-1:0] SP;
always @(posedge Clk) begin
    if (Rst) begin
        SP <= BUFFER_SIZE; // Initialize SP to BUFFER_SIZE (empty buffer)
    end else if (EN) begin
        if (!RW && SP > 0) begin // Push operation
            SP <= SP - 1;
        end else if (RW && SP < BUFFER_SIZE) begin // Pop operation
            SP <= SP + 1;
        end
    end
end

// Data Storage Module: Array of registers for data storage
reg [DATA_WIDTH-1:0] data_storage [0:BUFFER_SIZE-1];
always @(posedge Clk) begin
    if (Rst) begin
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            data_storage[i] <= {DATA_WIDTH{1'b0}}; // Initialize data storage to 0
        end
    end else if (EN) begin
        if (!RW && SP > 0) begin // Push operation
            data_storage[SP-1] <= dataIn; // Push data onto stack
        end else if (RW && SP < BUFFER_SIZE) begin // Pop operation
            dataOut <= data_storage[SP]; // Pop data from stack
            data_storage[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
        end
    end
end

// Control Module: Manages read/write operations, Empty/Full flags
always @(posedge Clk) begin
    if (Rst) begin
        EMPTY <= 1'b1; // Initialize EMPTY flag to 1 (buffer is empty)
        FULL <= 1'b0; // Initialize FULL flag to 0 (buffer is not full)
    end else if (EN) begin
        if (SP == BUFFER_SIZE) begin // Buffer is empty
            EMPTY <= 1'b1;
        end else begin
            EMPTY <= 1'b0;
        end
        if (SP == 0) begin // Buffer is full
            FULL <= 1'b1;
        end else begin
            FULL <= 1'b0;
        end
    end
end

// Clock Gating Module: Optimizes power consumption
wire clk_gated;
assign clk_gated = (EN || Rst)? Clk : 1'b0;

endmodule