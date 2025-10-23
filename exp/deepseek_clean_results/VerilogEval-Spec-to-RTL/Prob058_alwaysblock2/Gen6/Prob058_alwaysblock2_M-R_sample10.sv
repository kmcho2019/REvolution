module TopModule (
    input clk, a, b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Combinational outputs using assign only
    wire xor_result = a ^ b;
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;
    
    // Sequential output
    reg out_ff;
    always @(posedge clk) out_ff <= xor_result;
    assign out_always_ff = out_ff;

endmodule