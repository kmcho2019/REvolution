module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Method 1: Direct continuous assignment
    assign out_assign = a ^ b;
    
    // Method 2: Wire with continuous assignment (alternative to always_comb)
    wire comb_xor = a ^ b;
    assign out_always_comb = comb_xor;
    
    // Method 3: Sequential implementation with clocked flip-flop
    always @(posedge clk) begin
        out_always_ff <= comb_xor;  // Using same XOR computation
    end

endmodule