module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output wire out_always_comb,
    output reg out_always_ff
);

    // Shared XOR result for combinational outputs
    wire xor_result = a ^ b;
    
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;
    
    // Sequential logic with enable condition
    always @(posedge clk) begin
        if (a != b) begin  // Only update when inputs would change output
            out_always_ff <= xor_result;
        end
    end

endmodule