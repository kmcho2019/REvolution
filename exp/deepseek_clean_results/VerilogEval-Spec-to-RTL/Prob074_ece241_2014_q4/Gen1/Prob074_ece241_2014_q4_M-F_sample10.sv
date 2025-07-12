module TopModule (
    input clk,
    input x,
    output z
);

    // Declare flip-flop outputs
    reg ff_xor = 1'b0;
    reg ff_and = 1'b0;
    reg ff_or = 1'b0;

    // XOR gate input: x XOR ff_xor
    wire xor_in = x ^ ff_xor;

    // AND gate input: x AND ~ff_and
    wire and_in = x & (~ff_and);

    // OR gate input: x OR ~ff_or
    wire or_in = x | (~ff_or);

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        ff_xor <= xor_in;
        ff_and <= and_in;
        ff_or <= or_in;
    end

    // Output is NOR of all flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule