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

reg [1:0] SP; // Stack Pointer (2 bits for 4-entry stack)
reg [3:0] stack_mem [0:3]; // Stack Memory (4 bits wide, 4 entries deep)

always @(posedge Clk) begin
    if (Rst) begin
        SP <= 4; // Reset stack pointer to indicate empty buffer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0; // Initialize all memory locations to 0
        end
    end else if (EN) begin
        if (~RW && SP > 0) begin // Write operation and buffer not full
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW && SP < 4) begin // Read operation and buffer not empty
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= 4'b0; // Clear popped memory location
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

always @(*) begin
    if (SP == 4) begin
        EMPTY = 1'b1; // Buffer is empty
    end else begin
        EMPTY = 1'b0;
    end
    
    if (SP == 0) begin
        FULL = 1'b1; // Buffer is full
    end else begin
        FULL = 1'b0;
    end
end

endmodule