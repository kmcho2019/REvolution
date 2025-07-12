module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    reg internal_xor_result;

    always @(posedge clk or a or b) begin
        internal_xor_result = a ^ b;
        out_always_comb = internal_xor_result;
        out_assign = internal_xor_result;
        out_always_ff <= internal_xor_result;
    end

endmodule