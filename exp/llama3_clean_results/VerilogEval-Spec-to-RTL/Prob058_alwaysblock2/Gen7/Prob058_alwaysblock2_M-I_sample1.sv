module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Directly assign the result for out_assign and out_always_comb
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;
    
    // Use an always_ff block for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule