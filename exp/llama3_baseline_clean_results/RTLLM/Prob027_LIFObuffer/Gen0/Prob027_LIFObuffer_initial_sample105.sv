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

reg [3:0] stack_mem[0:3]; // 4-entry stack memory array
reg [1:0] SP; // stack pointer

// Initialize EMPTY and FULL flags
always @(*) begin
    EMPTY = (SP == 4);
    FULL = (SP == 0);
end

// Update stack memory and stack pointer on rising edge of clock
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 0;
        end
        SP <= 4;
    end else if (EN) begin
        if (~RW && !FULL) begin
            // Push data onto the stack for write operation
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
        end else if (RW && !EMPTY) begin
            // Pop data from the stack for read operation
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 0;
            SP <= SP + 1;
        end
    end
end

endmodule