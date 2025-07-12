module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff = 0, and_ff = 0, or_ff = 0;  // Explicit initialization to 0

    always @(posedge clk) begin
        xor_ff <= x ^ xor_ff;     // XOR with direct feedback
        and_ff <= x & ~and_ff;    // AND with complemented feedback
        or_ff  <= x | ~or_ff;     // OR with complemented feedback
    end

    // Three-input NOR gate (z = NOT (a OR b OR c))
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule