module LIFObuffer(
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem[3:0]; // Stack memory array
reg [1:0] SP; // Stack pointer

always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 2'b100; // Initialize stack pointer to 4 (empty buffer)
        EMPTY <= 1'b1; // Buffer is empty after reset
        FULL <= 1'b0; // Buffer is not full after reset
    end else if (EN) begin
        if (RW == 1'b0 && SP != 2'b000) begin
            // Push operation: write data to stack and decrement SP
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW == 1'b1 && SP != 2'b100) begin
            // Pop operation: read data from stack and increment SP
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0; // Clear the popped memory location
            SP <= SP + 1'b1;
        end
        // Update EMPTY and FULL flags
        EMPTY <= (SP == 2'b100) ? 1'b1 : 1'b0;
        FULL <= (SP == 2'b000) ? 1'b1 : 1'b0;
    end
end

endmodule