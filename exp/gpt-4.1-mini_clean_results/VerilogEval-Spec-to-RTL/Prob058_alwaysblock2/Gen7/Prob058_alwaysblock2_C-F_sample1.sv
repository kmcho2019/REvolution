module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Intermediate wire for XOR of a and b
    wire xor_result = a ^ b;

    // Continuous assignment outputs driven by xor_result
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;

    // Sequential always block registers xor_result on rising edge of clk
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule