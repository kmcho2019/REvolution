module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    wire xor_val = a ^ b;

    assign out_assign = xor_val;

    always @(*) out_always_comb = xor_val;

    always @(posedge clk) out_always_ff <= xor_val;

endmodule