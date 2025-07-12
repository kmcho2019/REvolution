module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal
    input Rst,           // Active high reset signal
    input Clk,           // Clock signal
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut  // 4-bit output data
);

reg [3:0] stack_mem [0:3];  // Stack memory array (4 locations, 4-bit wide)
reg [1:0] SP;              // Stack pointer (2-bit, 0-3 range)

// Initialize stack pointer and flags on reset
always @(posedge Clk) begin
    if (Rst) begin
        SP <= 4;  // Set stack pointer to 4 to indicate an empty buffer
        EMPTY <= 1'b1;  // Buffer is empty after reset
        FULL <= 1'b0;   // Buffer is not full after reset
        dataOut <= 4'b0;  // Clear dataOut on reset
        // Initialize stack memory locations to 0
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
    end else if (EN) begin
        // Perform push or pop operation based on RW signal
        if (!RW && (SP > 0)) begin  // Write operation and buffer is not full
            stack_mem[SP-1] <= dataIn;  // Push data onto the stack
            SP <= SP - 1;  // Decrement stack pointer
            EMPTY <= 1'b0;  // Buffer is not empty after push
        end else if (RW && (SP < 3)) begin  // Read operation and buffer is not empty
            dataOut <= stack_mem[SP];  // Pop data from the stack
            stack_mem[SP] <= 4'b0;  // Clear the popped stack location
            SP <= SP + 1;  // Increment stack pointer
            FULL <= 1'b0;  // Buffer is not full after pop
        end

        // Update EMPTY and FULL flags based on stack pointer
        if (SP == 4) begin
            EMPTY <= 1'b1;  // Buffer is empty when SP is 4
        end else if (SP == 0) begin
            FULL <= 1'b1;  // Buffer is full when SP is 0
        end else begin
            EMPTY <= 1'b0;  // Buffer is not empty
            FULL <= 1'b0;  // Buffer is not full
        end
    end
end

endmodule