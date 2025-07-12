module TopModule(
    input clk,
    input a,
    input b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    reg internal_xor;

    always @(a, b, clk) begin
        internal_xor = a ^ b;
        out_assign = internal_xor;
        out_always_comb = internal_xor;
        if (clk) begin
            out_always_ff <= internal_xor;
        end
    end

endmodule