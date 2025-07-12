module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg ff_xor, ff_and, ff_or;

    // Initialize flip-flops to 0
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or = 1'b0;
    end

    // Gate outputs (combinational logic)
    wire xor_out = x ^ ff_xor;    // XOR with its own output
    wire and_out = x & ~ff_and;   // AND with complement of its own output
    wire or_out = x | ff_or;      // OR with its own output (direct, not complemented)

    // Sequential logic (flip-flop updates)
    always @(posedge clk) begin
        ff_xor <= xor_out;
        ff_and <= and_out;
        ff_or <= or_out;
    end

    // Final output (NOR of all flip-flop outputs)
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule