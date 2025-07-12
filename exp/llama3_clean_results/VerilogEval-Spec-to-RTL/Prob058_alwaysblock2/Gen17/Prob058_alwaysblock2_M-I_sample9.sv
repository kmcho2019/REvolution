// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Directly implement the XOR logic for out_assign
    assign out_assign = a ^ b;
    
    // Directly implement the combinational logic for out_always_comb
    assign out_always_comb = a ^ b;
    
    // Implement the flip-flop logic directly for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule