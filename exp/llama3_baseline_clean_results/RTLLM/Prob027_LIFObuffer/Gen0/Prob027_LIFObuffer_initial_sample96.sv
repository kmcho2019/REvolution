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

// Define the stack memory array
reg [3:0] stack_mem [3:0];

// Define the stack pointer
reg [1:0] SP;

// Initialize the stack pointer and flags
initial begin
    SP = 4;
    EMPTY = 1'b1;
    FULL = 1'b0;
end

// Always block to handle the synchronous operations
always @ (posedge Clk) begin
    if (Rst) begin
        // Reset the stack
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 4;
        EMPTY <= 1'b1;
        FULL <= 1'b0;
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Write operation (push data onto the stack)
            stack_mem[SP-1] <= dataIn;
            SP <= SP - 1;
            EMPTY <= (SP == 4) ? 1'b1 : 1'b0;
            FULL <= (SP == 0) ? 1'b1 : 1'b0;
        end else if (RW && ~EMPTY) begin
            // Read operation (pop data from the stack)
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1;
            EMPTY <= (SP == 4) ? 1'b1 : 1'b0;
            FULL <= (SP == 0) ? 1'b1 : 1'b0;
        end else begin
            // No operation
        end
    end else begin
        // No operation
    end
end

endmodule