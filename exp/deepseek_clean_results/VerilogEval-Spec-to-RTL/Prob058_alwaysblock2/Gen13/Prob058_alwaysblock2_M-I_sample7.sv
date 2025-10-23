module TopModule (
    input clk, a, b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    wire comb_xor = a ^ b;
    
    assign out_assign = comb_xor;
    assign out_always_comb = comb_xor;
    
    always @(posedge clk) out_always_ff <= comb_xor;

endmodule