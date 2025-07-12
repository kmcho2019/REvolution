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

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer

always @ (posedge Clk) begin
    if (EN) begin
        if (Rst) begin // Reset condition
            SP <= 4; // Initialize stack pointer to indicate empty buffer
            for (int i = 0; i < 4; i++) begin
                stack_mem[i] <= 4'b0; // Clear all memory locations
            end
        end else begin // Normal operation
            if (~RW && SP != 0) begin // Write operation and buffer not full
                stack_mem[SP - 1] <= dataIn; // Push data onto the stack
                SP <= SP - 1; // Decrement stack pointer
            end else if (RW && SP != 4) begin // Read operation and buffer not empty
                dataOut <= stack_mem[SP]; // Pop data from the stack
                stack_mem[SP] <= 4'b0; // Clear the popped memory location
                SP <= SP + 1; // Increment stack pointer
            end
        end
    end
end

always @ (*) begin
    EMPTY = (SP == 4); // Update EMPTY flag
    FULL = (SP == 0); // Update FULL flag
end

endmodule