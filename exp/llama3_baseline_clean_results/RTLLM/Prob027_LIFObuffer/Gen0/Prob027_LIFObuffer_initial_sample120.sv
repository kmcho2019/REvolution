module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output EMPTY,      // Flag indicating whether the buffer is empty
    output FULL,       // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3];  // Stack memory array
reg [1:0] SP;             // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin  // Active high reset
        SP <= 4;    // Set stack pointer to indicate an empty buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;  // Initialize all memory locations to 0
        end
    end else if (EN) begin  // Enable signal is high
        if (~RW && SP > 0) begin  // Write operation and buffer is not full
            stack_mem[SP-1] <= dataIn;  // Push data onto the stack
            SP <= SP - 1;              // Decrement stack pointer
        end else if (RW && SP < 4) begin  // Read operation and buffer is not empty
            dataOut <= stack_mem[SP];  // Pop data from the stack into dataOut
            stack_mem[SP] <= 4'b0;      // Clear the corresponding stack memory
            SP <= SP + 1;              // Increment stack pointer
        end
    end
end

assign EMPTY = (SP == 4);  // Buffer is empty if stack pointer is 4
assign FULL = (SP == 0);   // Buffer is full if stack pointer is 0

endmodule