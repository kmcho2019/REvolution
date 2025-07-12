module TopModule (
    input clk, a, b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    wire xor_result = a ^ b;
    
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;
    
    always @(posedge clk) out_always_ff <= xor_result;

endmodule