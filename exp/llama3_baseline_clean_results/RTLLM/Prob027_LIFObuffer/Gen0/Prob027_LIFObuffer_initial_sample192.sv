module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data
    input RW,          // Read/Write control signal
    input EN,          // Enable signal
    input Rst,         // Active high reset signal
    input Clk,         // Clock signal
    output reg EMPTY,  // Flag indicating whether the buffer is empty
    output reg FULL,   // Flag indicating whether the buffer is full
    output reg [3:0] dataOut  // 4-bit output data
);

reg [3:0] stack_mem[0:3];  // Stack memory array
reg [1:0] SP;            // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin  // Reset the buffer
        SP <= 4;  // Set stack pointer to 4 (indicating an empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0;  // Initialize all memory locations to 0
        end
    end else if (EN) begin  // Enable buffer operations
        if (~RW && ~FULL) begin  // Write operation and buffer is not full
            stack_mem[SP] <= dataIn;  // Push data onto the stack
            SP <= SP - 1;  // Decrement stack pointer
        end else if (RW && ~EMPTY) begin  // Read operation and buffer is not empty
            dataOut <= stack_mem[SP + 1];  // Pop data from the stack into dataOut
            stack_mem[SP + 1] <= 0;  // Clear the corresponding stack memory
            SP <= SP + 1;  // Increment stack pointer
        end
    end
end

always @(*) begin
    if (SP == 4) begin  // Stack pointer is 4 (indicating an empty buffer)
        EMPTY = 1'b1;
        FULL = 1'b0;
    end else if (SP == 0) begin  // Stack pointer is 0 (indicating a full buffer)
        EMPTY = 1'b0;
        FULL = 1'b1;
    end else begin  // Buffer is neither empty nor full
        EMPTY = 1'b0;
        FULL = 1'b0;
    end
end

endmodule