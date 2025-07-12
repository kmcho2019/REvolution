module LIFObuffer(
    input logic Clk,
    input logic Rst,
    input logic EN,
    input logic RW,
    input logic [3:0] dataIn,
    output logic EMPTY,
    output logic FULL,
    output logic [3:0] dataOut
);

// Stack memory declaration
logic [3:0] stack_mem [3:0];

// Stack pointer declaration
logic [1:0] SP;

// Assign output based on stack pointer
always_comb begin
    if (SP == 4'd4) begin
        EMPTY = 1'b1;
        FULL = 1'b0;
    end else if (SP == 4'd0) begin
        EMPTY = 1'b0;
        FULL = 1'b1;
    end else begin
        EMPTY = 1'b0;
        FULL = 1'b0;
    end
end

// Sequential logic for stack operations
always_ff @(posedge Clk) begin
    if (Rst) begin
        // Reset the stack and stack pointer
        for (int i = 0; i < 4; i++) begin
            stack_mem[i] <= 4'd0;
        end
        SP <= 4'd4;
    end else if (EN) begin
        if (~RW && ~FULL) begin
            // Push data onto the stack
            stack_mem[SP - 1] <= dataIn;
            SP <= SP - 1'b1;
        end else if (RW && ~EMPTY) begin
            // Pop data from the stack
            dataOut <= stack_mem[SP];
            stack_mem[SP] <= 4'd0;
            SP <= SP + 1'b1;
        end
    end
end

// Continuous assignment for output data
assign dataOut = (EMPTY)? 4'd0 : stack_mem[SP];

endmodule