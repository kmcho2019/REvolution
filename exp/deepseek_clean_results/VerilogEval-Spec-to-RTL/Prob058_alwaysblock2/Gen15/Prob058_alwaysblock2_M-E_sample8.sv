module TopModule #(
    parameter LUT_WIDTH = 2
) (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Configuration check
    initial begin
        if (LUT_WIDTH != 2) 
            $display("Warning: LUT_WIDTH parameter modified from default value 2");
    end

    // 1. LUT-style implementation using ternary operator
    assign out_assign = a ? (b ? 1'b0 : 1'b1) : (b ? 1'b1 : 1'b0);

    // 2. Truth table implementation using case statement
    always @(*) begin
        case ({a, b})
            2'b00: out_always_comb = 1'b0;
            2'b01: out_always_comb = 1'b1;
            2'b10: out_always_comb = 1'b1;
            2'b11: out_always_comb = 1'b0;
            default: out_always_comb = 1'bx; // Undefined state handling
        endcase
    end

    // 3. Pipelined version with explicit state register
    reg state;
    always @(posedge clk) begin
        state <= a ^ b;          // First stage: compute XOR
        out_always_ff <= state;   // Second stage: output register
    end

endmodule