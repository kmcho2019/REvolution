module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data
    input RW,          // Read/Write control signal
    input EN,          // Enable signal
    input Rst,         // Active high reset signal
    input Clk,         // Clock signal
    output reg EMPTY,  // Flag indicating whether the buffer is empty
    output reg FULL,   // Flag indicating whether the buffer is full
    output reg [3:0] dataOut // 4-bit output data
);

reg [3:0] stack_mem[3:0]; // 4-element stack memory array
reg [1:0] SP;            // 2-bit stack pointer

// Initialize the stack pointer and flags
always @(*) begin
    EMPTY = (SP == 4);
    FULL = (SP == 0);
end

// Update the stack pointer and memory on the rising edge of the clock
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and initialize the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
    end else if (EN) begin
        if (!RW && !FULL) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && !EMPTY) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
        end
    end
end

endmodule