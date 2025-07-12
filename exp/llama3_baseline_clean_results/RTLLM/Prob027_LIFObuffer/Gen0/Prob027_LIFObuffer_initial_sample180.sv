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

// Define the size of the stack
parameter SIZE = 4;

// Declare the stack memory array
reg [3:0] stack_mem [0:SIZE-1];

// Declare the stack pointer
reg [1:0] SP;

// Initialize the stack pointer and flags
initial begin
    SP = 4;
    EMPTY = 1'b1;
    FULL = 1'b0;
    dataOut = 4'b0;
end

// Process on the rising edge of the clock
always @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < SIZE; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Push data onto the stack
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
            EMPTY <= 1'b0;
            if (SP == 0) begin
                FULL <= 1'b1;
            end
        end else if (RW && ~EMPTY) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
            FULL <= 1'b0;
            if (SP == 4) begin
                EMPTY <= 1'b1;
            end
        end
    end
end

endmodule