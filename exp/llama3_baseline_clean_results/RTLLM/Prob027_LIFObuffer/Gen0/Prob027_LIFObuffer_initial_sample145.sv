module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output reg EMPTY,  // Flag indicating whether the buffer is empty
    output reg FULL,   // Flag indicating whether the buffer is full
    output reg [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3];  // Stack memory array
reg [1:0] SP;             // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin  // Reset condition
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;  // Initialize stack memory to 0
        end
        SP <= 4;  // Set stack pointer to 4 (empty buffer)
        EMPTY <= 1'b1;  // Set EMPTY flag high
        FULL <= 1'b0;  // Set FULL flag low
    end else if (EN) begin  // Enable condition
        if (~RW && SP != 4) begin  // Write operation
            stack_mem[SP] <= dataIn;  // Push data onto the stack
            SP <= SP - 1;  // Decrement stack pointer
        end else if (RW && SP != 0) begin  // Read operation
            dataOut <= stack_mem[SP];  // Pop data from the stack
            stack_mem[SP] <= 4'b0;  // Clear popped data
            SP <= SP + 1;  // Increment stack pointer
        end
    end

    // Update EMPTY and FULL flags
    if (SP == 4) begin
        EMPTY <= 1'b1;  // Buffer is empty
        FULL <= 1'b0;
    end else if (SP == 0) begin
        EMPTY <= 1'b0;
        FULL <= 1'b1;  // Buffer is full
    end else begin
        EMPTY <= 1'b0;
        FULL <= 1'b0;
    end
end

endmodule