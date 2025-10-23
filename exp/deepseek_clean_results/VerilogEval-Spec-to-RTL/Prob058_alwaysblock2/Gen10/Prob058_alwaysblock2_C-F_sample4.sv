module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    parameter DELAY_CYCLES = 1;  // Configurable delay depth
    parameter RESET_VAL = 1'b0;  // Reset value for sequential output
    
    // Shared XOR computation
    wire shared_xor = a ^ b;
    
    // Continuous assignment
    assign out_assign = shared_xor;
    
    // Combinational always block
    always @(*) begin
        out_always_comb = shared_xor;
    end
    
    // Sequential implementation - optimized for common case
    generate
        if (DELAY_CYCLES == 1) begin : single_cycle
            // Simple single-cycle delay
            always @(posedge clk) begin
                out_always_ff <= shared_xor;
            end
        end
        else begin : multi_cycle
            // Parameterized delay pipeline
            reg [DELAY_CYCLES-1:0] delay_chain;
            always @(posedge clk) begin
                delay_chain <= {delay_chain[DELAY_CYCLES-2:0], shared_xor};
                out_always_ff <= delay_chain[DELAY_CYCLES-1];
            end
        end
    endgenerate

endmodule