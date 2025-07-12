module TopModule (
    input clk, a, b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;
    
    always @(posedge clk) out_always_ff <= a ^ b;

endmodule