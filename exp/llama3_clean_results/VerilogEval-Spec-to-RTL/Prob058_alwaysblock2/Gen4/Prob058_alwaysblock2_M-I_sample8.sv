module TopModule (
    input  clk,
    input  a,
    input  b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

assign out_assign = a ^ b;

always_comb out_always_comb = a ^ b;

always_ff @(posedge clk) out_always_ff <= a ^ b;

endmodule