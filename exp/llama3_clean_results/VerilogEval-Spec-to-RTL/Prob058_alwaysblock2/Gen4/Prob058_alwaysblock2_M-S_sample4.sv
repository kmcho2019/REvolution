module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Directly implement XOR for out_assign using assign statement
    assign out_assign = a ^ b;
    
    // Directly implement XOR for out_always_comb within an always_comb block
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Implement XOR and flip-flop for out_always_ff within an always_ff block
    always_ff @(posedge clk) begin
        out_always_ff = a ^ b;
    end
    
endmodule