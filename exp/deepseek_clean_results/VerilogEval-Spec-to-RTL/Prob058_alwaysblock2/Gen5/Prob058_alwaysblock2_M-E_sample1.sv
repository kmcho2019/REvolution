module TopModule #(
    parameter DELAY_CYCLES = 1
) (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Shared XOR result
    wire xor_result = a ^ b;
    
    // Continuous assignment
    assign out_assign = xor_result;
    
    // Combinational always block
    assign out_always_comb = xor_result;
    
    // Sequential implementation with configurable delay
    reg [DELAY_CYCLES-1:0] delay_ff;
    always_ff @(posedge clk) begin
        delay_ff <= {delay_ff[DELAY_CYCLES-2:0], xor_result};
    end
    assign out_always_ff = delay_ff[DELAY_CYCLES-1];

endmodule