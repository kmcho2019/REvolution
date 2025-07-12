module TopModule #(
    parameter DELAY_CYCLES = 1  // Configurable delay (0 for combinational, >=1 for sequential)
)(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Common XOR computation
    wire xor_value = a ^ b;

    // Continuous assignment
    assign out_assign = xor_value;

    // Combinational always block
    assign out_always_comb = xor_value;

    // Sequential implementation with configurable delay
    generate
        if (DELAY_CYCLES == 0) begin
            // Bypass mode - behaves like combinational
            assign out_always_ff = xor_value;
        end
        else begin
            // Shift register implementation
            reg [DELAY_CYCLES-1:0] delay_line;
            
            always @(posedge clk) begin
                delay_line <= {delay_line[DELAY_CYCLES-2:0], xor_value};
            end
            
            assign out_always_ff = delay_line[DELAY_CYCLES-1];
        end
    endgenerate

endmodule