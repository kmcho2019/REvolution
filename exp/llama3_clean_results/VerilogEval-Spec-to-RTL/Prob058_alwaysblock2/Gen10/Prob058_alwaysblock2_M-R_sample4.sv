// TopModule implementation with refactored structure
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    
    // Temporary wire to compute the XOR result
    wire xor_result;
    
    // Assign the XOR result to out_assign directly
    assign out_assign = xor_result;
    
    // Combinational always block to handle out_always_comb and compute xor_result
    always_comb begin
        xor_result = a ^ b;
        out_always_comb = xor_result;
    end
    
    // Implement the flip-flop logic directly for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule