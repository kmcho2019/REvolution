module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Common XOR result for combinational outputs
    wire xor_result = a ^ b;
    
    // Continuous assignments for combinational outputs
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;

    // Sequential always block (flip-flop)
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule