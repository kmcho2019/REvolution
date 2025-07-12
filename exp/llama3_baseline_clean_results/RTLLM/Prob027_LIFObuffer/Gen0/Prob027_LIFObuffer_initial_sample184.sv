module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output EMPTY,      // Flag indicating whether the buffer is empty
    output FULL,       // Flag indicating whether the buffer is full
    output [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3]; // Stack memory array to store the data
reg [1:0] SP;            // Stack pointer to track the current position in the stack

assign EMPTY = (SP == 4); // Buffer is empty when SP is at the maximum stack size
assign FULL = (SP == 0);  // Buffer is full when SP is at 0

always @(posedge Clk) begin
    if (Rst) begin // Reset the buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize all memory locations to 0
        end
        SP <= 4; // Reset the stack pointer to the maximum stack size
    end else if (EN) begin // Enable buffer operations
        if (~RW && ~FULL) begin // Push operation (RW = 0) when the buffer is not full
            stack_mem[SP - 1] <= dataIn; // Store the input data in the current stack position
            SP <= SP - 1; // Decrement the stack pointer
        end else if (RW && ~EMPTY) begin // Pop operation (RW = 1) when the buffer is not empty
            dataOut <= stack_mem[SP]; // Retrieve the data from the current stack position
            stack_mem[SP] <= 4'b0; // Clear the corresponding stack memory
            SP <= SP + 1; // Increment the stack pointer
        end
    end
end

endmodule