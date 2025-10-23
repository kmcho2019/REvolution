module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output wire out_always_ff
);

    // Parameters for configurability
    parameter DELAY_CYCLES = 1;  // Configurable delay for sequential output
    
    // Combinational XOR module (assign style)
    module comb_xor_assign (
        input  wire a,
        input  wire b,
        output wire out
    );
        assign out = a ^ b;
    endmodule
    
    // Combinational XOR module (always_comb style)
    module comb_xor_always (
        input  wire a,
        input  wire b,
        output reg out
    );
        always @(*) begin
            out = a ^ b;
        end
    endmodule
    
    // Sequential XOR module with configurable delay
    module seq_xor_ff #(parameter DELAY = 1) (
        input  wire clk,
        input  wire a,
        input  wire b,
        output reg out
    );
        reg [DELAY-1:0] delay_chain;
        wire xor_result = a ^ b;
        
        always @(posedge clk) begin
            if (DELAY == 1) begin
                out <= xor_result;
            end else begin
                delay_chain <= {delay_chain[DELAY-2:0], xor_result};
                out <= delay_chain[DELAY-1];
            end
        end
    endmodule
    
    // Instantiate all three implementations
    comb_xor_assign assign_impl (.a(a), .b(b), .out(out_assign));
    comb_xor_always always_impl (.a(a), .b(b), .out(out_always_comb));
    seq_xor_ff #(.DELAY(DELAY_CYCLES)) ff_impl (.clk(clk), .a(a), .b(b), .out(out_always_ff));

endmodule