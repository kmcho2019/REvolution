module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg ff_xor, ff_and, ff_or;

    // Gate outputs (inputs to flip-flops)
    wire d_xor, d_and, d_or;

    // XOR gate: x XOR ff_xor (non-complemented)
    assign d_xor = x ^ ff_xor;

    // AND gate: x AND ~ff_and (complemented)
    assign d_and = x & (~ff_and);

    // OR gate: x OR ~ff_or (complemented)
    assign d_or = x | (~ff_or);

    // Three-input NOR gate for final output
    assign z = ~(ff_xor | ff_and | ff_or);

    // Flip-flops (positive edge triggered, initially 0)
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or <= d_or;
    end

endmodule