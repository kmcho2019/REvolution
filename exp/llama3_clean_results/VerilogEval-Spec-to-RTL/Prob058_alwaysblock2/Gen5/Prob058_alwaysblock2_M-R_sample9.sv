// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Implement XOR gate using assign statement for out_assign
    assign out_assign = a ^ b;
    
    // Implement combinational XOR gate using assign statement for out_always_comb
    assign out_always_comb = a ^ b;
    
    // Implement flip-flop for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule