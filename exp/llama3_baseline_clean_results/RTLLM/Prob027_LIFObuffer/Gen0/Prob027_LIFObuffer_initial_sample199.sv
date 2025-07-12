module LIFObuffer(
    input [3:0] dataIn,  // 4-bit input data to be pushed onto the buffer
    input RW,          // Read/Write control signal (1 for read, 0 for write)
    input EN,          // Enable signal to activate buffer operations
    input Rst,         // Active high reset signal to initialize the buffer
    input Clk,         // Clock signal for synchronous operations
    output EMPTY,      // Flag indicating whether the buffer is empty
    output FULL,       // Flag indicating whether the buffer is full
    output [3:0] dataOut  // 4-bit output data retrieved from the buffer
);

reg [3:0] stack_mem[3:0];  // Stack memory array
reg [1:0] SP;            // Stack pointer

// Initialize flags for EMPTY and FULL
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and set the stack pointer to 4 (indicating an empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 2'd4;
    end else if (EN) begin
        if (!RW && !FULL) begin
            // Push data onto the stack if the buffer is not full
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && !EMPTY) begin
            // Pop data from the stack if the buffer is not empty
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
        end
    end
end

endmodule