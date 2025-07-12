module LIFObuffer (
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output EMPTY,
    output FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // Stack memory array
reg [1:0] SP; // Stack pointer, initialized to 4 (empty buffer)

assign EMPTY = (SP == 4); // Buffer is empty when SP is equal to 4
assign FULL = (SP == 0); // Buffer is full when SP is 0

// Sequential logic for stack pointer and stack memory
always @(posedge Clk) begin
    if (Rst) begin // Active high reset
        SP <= 2'd4; // Initialize stack pointer to 4 (empty buffer)
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0; // Initialize stack memory to 0
        end
        dataOut <= 4'd0;
    end else if (EN) begin // Enable signal is high
        if (!RW && !FULL) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (RW && !EMPTY) begin // Pop operation
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= 4'd0; // Clear popped data
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

endmodule