module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output wire out_always_comb,
    output reg out_always_ff
);

    // Shared XOR result for both combinational outputs
    wire xor_result = a ^ b;
    
    // Continuous assignment using shared result
    assign out_assign = xor_result;
    
    // Combinational output using same shared result
    assign out_always_comb = xor_result;
    
    // Sequential implementation remains unchanged
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule