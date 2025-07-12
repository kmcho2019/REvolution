// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output reg out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);
    
    // Implement XOR gate using assign statement
    assign out_assign = a ^ b;
    
    // Implement combinational always block using assign
    assign out_always_comb = a ^ b;
    
    // Implement clocked always block with flip-flop
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule