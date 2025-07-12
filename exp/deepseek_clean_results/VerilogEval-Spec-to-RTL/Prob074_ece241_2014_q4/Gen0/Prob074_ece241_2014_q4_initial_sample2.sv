module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Gate outputs (D inputs to flip-flops)
    wire d_xor, d_and, d_or;

    // XOR path: x XOR q_xor
    assign d_xor = x ^ q_xor;

    // AND path: x AND ~q_and
    assign d_and = x & ~q_and;

    // OR path: x OR ~q_or
    assign d_or = x | ~q_or;

    // Flip-flops (positive edge triggered, initially 0)
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or <= d_or;
    end

    // Final output: NOR of all flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule