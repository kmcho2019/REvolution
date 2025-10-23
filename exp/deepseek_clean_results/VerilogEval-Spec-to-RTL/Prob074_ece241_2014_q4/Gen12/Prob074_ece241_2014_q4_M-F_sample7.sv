module TopModule (
    input clk,
    input x,
    output z
);

    // Separate flip-flops for each path
    reg xor_ff = 1'b0;
    reg and_ff = 1'b0;
    reg or_ff = 1'b0;

    // XOR path: feedback is flip-flop output
    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;
    end

    // AND path: feedback is complemented flip-flop output
    always @(posedge clk) begin
        and_ff <= x & ~and_ff;
    end

    // OR path: feedback is complemented flip-flop output
    always @(posedge clk) begin
        or_ff <= x | ~or_ff;
    end

    // Output NOR gate combining all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule