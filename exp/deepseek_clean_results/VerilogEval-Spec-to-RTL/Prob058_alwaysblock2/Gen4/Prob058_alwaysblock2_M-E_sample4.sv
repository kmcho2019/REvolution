module TopModule #(
    parameter INVERT_OUTPUT = 0  // 0 for XOR, 1 for XNOR
)(
    input clk,
    input a,
    input b,
    input reset,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment with configurable operation
    assign out_assign = INVERT_OUTPUT ? ~(a ^ b) : (a ^ b);

    // Combinational always block with case for future expansion
    always @(*) begin
        case (INVERT_OUTPUT)
            1'b0: out_always_comb = a ^ b;
            1'b1: out_always_comb = ~(a ^ b);
        endcase
    end

    // Sequential block with reset and configurable operation
    always @(posedge clk) begin
        if (reset) begin
            out_always_ff <= 1'b0;
        end else begin
            case (INVERT_OUTPUT)
                1'b0: out_always_ff <= a ^ b;
                1'b1: out_always_ff <= ~(a ^ b);
            endcase
        end
    end

endmodule