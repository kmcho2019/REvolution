module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data
    input RW,            // Read/Write control signal (1 for read, 0 for write)
    input EN,            // Enable signal to activate buffer operations
    input Rst,           // Active high reset signal
    input Clk,           // Clock signal for synchronous operations
    output reg EMPTY,    // Flag indicating whether the buffer is empty
    output reg FULL,     // Flag indicating whether the buffer is full
    output reg [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem [0:3];  // Stack memory array
reg [1:0] SP;              // Stack pointer

// Initialize stack pointer and flags
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and flags
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0;
        end
        SP <= 4;
        EMPTY <= 1;
        FULL <= 0;
        dataOut <= 0;
    end
    else if (EN) begin
        // Update flags and dataOut
        if (SP == 4) begin
            EMPTY <= 1;
            FULL <= 0;
        end
        else if (SP == 0) begin
            EMPTY <= 0;
            FULL <= 1;
        end
        else begin
            EMPTY <= 0;
            FULL <= 0;
        end

        // Perform read or write operation
        if (RW) begin
            // Read operation
            if (!EMPTY) begin
                dataOut <= stack_mem[SP];
                stack_mem[SP] <= 0;
                SP <= SP + 1;
            end
        end
        else begin
            // Write operation
            if (!FULL) begin
                SP <= SP - 1;
                stack_mem[SP] <= dataIn;
            end
        end
    end
end

endmodule