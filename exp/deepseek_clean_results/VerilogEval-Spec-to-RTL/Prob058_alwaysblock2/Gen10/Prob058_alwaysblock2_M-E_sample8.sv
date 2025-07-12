module TopModule #(
    parameter DELAY_CYCLES = 1,  // Configurable delay
    parameter USE_REGISTERED_COMB = 0  // Option to register comb outputs
)(
    input clk, a, b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Internal XOR result
    wire xor_result = a ^ b;
    
    // Traditional assign statement
    assign out_assign = xor_result;
    
    // Combinational always block with optional registration
    generate
        if (USE_REGISTERED_COMB) begin
            always @(posedge clk) out_always_comb <= xor_result;
        end else begin
            always @(*) out_always_comb = xor_result;
        end
    endgenerate
    
    // Sequential implementation with configurable delay
    reg [DELAY_CYCLES-1:0] delay_chain;
    always @(posedge clk) begin
        delay_chain <= {delay_chain[DELAY_CYCLES-2:0], xor_result};
        out_always_ff <= delay_chain[DELAY_CYCLES-1];
    end

endmodule