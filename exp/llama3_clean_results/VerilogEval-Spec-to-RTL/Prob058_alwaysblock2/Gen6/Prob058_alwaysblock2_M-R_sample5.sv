module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Implement XOR gate using assign statement
    assign out_assign = a ^ b;
    
    // Implement XOR gate using combinational always block
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Implement XOR gate with flip-flop using clocked always block
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule