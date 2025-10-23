module TopModule (
    input clk, a, b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Single XOR computation shared by all outputs
    wire xor_result = a ^ b;
    
    // Combinational outputs
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;
    
    // Sequential output with direct always_ff implementation
    always @(posedge clk) begin
        out_always_ff <= xor_result;
    end

endmodule