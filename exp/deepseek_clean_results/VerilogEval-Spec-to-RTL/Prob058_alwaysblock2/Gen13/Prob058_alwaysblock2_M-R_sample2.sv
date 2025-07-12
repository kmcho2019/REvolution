module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // All three implementations of XOR gate
    
    // 1. Continuous assignment (original)
    assign out_assign = a ^ b;
    
    // 2. Changed from always_comb to continuous assignment
    wire comb_xor = a ^ b;
    assign out_always_comb = comb_xor;
    
    // 3. Sequential always block (unchanged)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule