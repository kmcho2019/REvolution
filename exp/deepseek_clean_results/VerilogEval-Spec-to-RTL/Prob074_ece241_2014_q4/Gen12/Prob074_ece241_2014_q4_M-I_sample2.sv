module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;

    // All flip-flop updates in one always block for better synthesis
    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;     // XOR with direct feedback
        and_ff <= x & ~and_ff;    // AND with complemented feedback
        or_ff  <= x | ~or_ff;     // OR with complemented feedback
    end

    // Three-input NOR gate output
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule