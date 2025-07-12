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

// Declare the stack memory
reg [3:0] stack_mem [3:0];

// Declare the stack pointer
reg [1:0] SP;

// Initialize the stack pointer and flags
initial begin
    SP = 4'b100;
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// Process data on the rising edge of the clock
always @(posedge Clk) begin
    if (Rst) begin
        // Clear the stack and reset the stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'b0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Push data onto the stack (write operation)
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1;
            EMPTY <= 1'b0;
        end else if (RW && ~EMPTY) begin
            // Pop data from the stack (read operation)
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'b0;
            SP <= SP + 1;
            FULL <= 1'b0;
        end
        // Update the flags
        if (SP == 4) begin
            EMPTY <= 1'b1;
        end
        if (SP == 0) begin
            FULL <= 1'b1;
        end
    end
end

endmodule