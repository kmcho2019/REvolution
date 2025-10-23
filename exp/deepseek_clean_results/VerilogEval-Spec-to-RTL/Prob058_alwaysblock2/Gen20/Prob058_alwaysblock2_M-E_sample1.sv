module TopModule (
    input clk, a, b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Parameters for configurability
    parameter USE_RESET = 0;
    parameter RESET_POLARITY = 1;

    // Internal signals
    wire xor_result;
    reg out_ff;
    reg last_a, last_b;
    wire clk_enable;

    // Instantiate XOR core module
    XORCore xor_inst (
        .a(a),
        .b(b),
        .result(xor_result)
    );

    // Continuous assignment
    assign out_assign = xor_result;

    // Combinational always equivalent
    assign out_always_comb = xor_result;

    // Input change detection for clock gating
    always @(posedge clk) begin
        last_a <= a;
        last_b <= b;
    end

    assign clk_enable = (a != last_a) || (b != last_b);

    // Sequential output with conditional clock gating
    generate
        if (USE_RESET) begin
            always @(posedge clk) begin
                if (reset == RESET_POLARITY)
                    out_ff <= 1'b0;
                else if (clk_enable)
                    out_ff <= xor_result;
            end
        end else begin
            always @(posedge clk) begin
                if (clk_enable)
                    out_ff <= xor_result;
            end
        end
    endgenerate

    assign out_always_ff = out_ff;

endmodule

// Separate XOR core module
module XORCore (
    input a, b,
    output result
);
    assign result = a ^ b;
endmodule