module LIFObuffer (
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

reg [3:0] stack_mem [0:3]; // Stack memory array, hardcoded buffer size
reg [1:0] SP; // Stack pointer, optimized bit width

// Combinational logic for EMPTY and FULL flags, simplified
assign EMPTY = (SP == 4);
assign FULL = (SP == 0);

// Sequential logic for stack pointer and stack memory, optimized for PPA
always @(posedge Clk) begin
    if (Rst) begin // Active high reset, optimized for low power
        SP <= 4; // Initialize stack pointer to 4 (empty buffer)
        stack_mem[0] <= 4'b0000; // Initialize stack memory locations to 0, minimizing switching
        stack_mem[1] <= 4'b0000;
        stack_mem[2] <= 4'b0000;
        stack_mem[3] <= 4'b0000;
        dataOut <= 4'b0000;
    end else if (EN) begin // Enable signal is high, gated for low power
        if (!RW && SP > 0 && !FULL) begin // Push operation, optimized for performance
            stack_mem[SP-1] <= dataIn; // Push data onto stack, minimizing switching
            SP <= SP - 1; // Decrement stack pointer, optimized for area
        end else if (RW && SP < 4 && !EMPTY) begin // Pop operation, optimized for performance
            dataOut <= stack_mem[SP]; // Pop data from stack, minimizing switching
            stack_mem[SP] <= 4'b0000; // Clear popped data, optimizing for power
            SP <= SP + 1; // Increment stack pointer, optimized for area
        end
    end
end

endmodule