module LIFObuffer(
    input [3:0] dataIn, // 4-bit input data to be pushed onto the buffer
    input RW, // Read/Write control signal (1 for read, 0 for write)
    input EN, // Enable signal to activate buffer operations
    input Rst, // Active high reset signal to initialize the buffer
    input Clk, // Clock signal for synchronous operations
    output reg EMPTY, // Flag indicating whether the buffer is empty
    output reg FULL, // Flag indicating whether the buffer is full
    output reg [3:0] dataOut // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [3:0]; // Stack memory array
reg [1:0] SP; // Stack pointer (2 bits to represent 4 positions)

always @(posedge Clk) begin
    if (Rst) begin // Reset the buffer
        SP <= 4; // Initialize stack pointer to indicate an empty buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0; // Initialize all memory locations to 0
        end
        EMPTY <= 1'b1; // Set EMPTY flag
        FULL <= 1'b0; // Clear FULL flag
    end else if (EN) begin // Enable buffer operations
        if (RW == 0) begin // Write operation
            if (SP > 0) begin // Buffer is not full
                stack_mem[SP - 1] <= dataIn; // Push data onto the stack
                SP <= SP - 1; // Decrement stack pointer
            end
        end else begin // Read operation
            if (SP < 4) begin // Buffer is not empty
                dataOut <= stack_mem[SP]; // Pop data from the stack
                stack_mem[SP] <= 0; // Clear the corresponding stack memory
                SP <= SP + 1; // Increment stack pointer
            end
        end
    end
end

always @(*) begin
    if (SP == 4) begin // Buffer is empty
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (SP == 0) begin // Buffer is full
        EMPTY <= 1'b0;
        FULL <= 1'b1;
    end else begin // Buffer is neither empty nor full
        EMPTY <= 1'b0;
        FULL <= 1'b0;
    end
end

endmodule