// Define the TopModule with built-in XOR and flip-flop logic
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Use assign for out_assign
    assign out_assign = a ^ b;
    
    // Use assign for out_always_comb
    assign out_always_comb = a ^ b;
    
    // Use a built-in flip-flop for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b; // Non-blocking assignment for sequential logic
    end
    
endmodule