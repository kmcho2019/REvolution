module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data
    input RW,            // Read/Write control signal
    input EN,            // Enable signal
    input Rst,           // Active high reset signal
    input Clk,           // Clock signal
    output EMPTY,        // Flag indicating whether the buffer is empty
    output FULL,         // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data
);

// Define the size of the stack
parameter SIZE = 4;

// Define the stack memory array
reg [3:0] stack_mem [SIZE-1:0];

// Define the stack pointer
reg [1:0] SP;

// Initialize the stack pointer
initial SP = 4;

// Reset the stack and stack pointer
always @(posedge Clk) begin
    if (Rst) begin
        SP <= 4;
        for (int i = 0; i < SIZE; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end
    // Push data onto the stack if the buffer is not full
    else if (EN &&!RW && SP > 0) begin
        stack_mem[SP-1] <= dataIn;
        SP <= SP - 1;
    end
    // Pop data from the stack if the buffer is not empty
    else if (EN && RW && SP < 4) begin
        dataOut <= stack_mem[SP];
        stack_mem[SP] <= 4'b0;
        SP <= SP + 1;
    end
end

// Update the EMPTY and FULL flags
always @(posedge Clk) begin
    if (SP == 4) begin
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (SP == 0) begin
        EMPTY <= 1'b0;
        FULL <= 1'b1;
    end else begin
        EMPTY <= 1'b0;
        FULL <= 1'b0;
    end
end

// Output the data from the stack
always @(posedge Clk) begin
    if (RW && EN && SP < 4) begin
        dataOut <= stack_mem[SP];
    end else begin
        dataOut <= 4'b0;
    end
end

endmodule