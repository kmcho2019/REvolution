module TopModule (
    input clk,
    input x,
    output z
);

    // Declare flip-flop outputs
    reg ff_xor, ff_and, ff_or;

    // Initialize flip-flops to 0
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or = 1'b0;
    end

    // XOR gate: x XOR with ff_xor
    wire xor_out = x ^ ff_xor;

    // AND gate: x AND with ~ff_and
    wire and_out = x & (~ff_and);

    // OR gate: x OR with ~ff_or
    wire or_out = x | (~ff_or);

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        ff_xor <= xor_out;
        ff_and <= and_out;
        ff_or <= or_out;
    end

    // 3-input NOR gate for output z
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule