module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg ff_xor, ff_and, ff_or;

    // Input logic for each flip-flop
    wire xor_in = x ^ ff_xor;
    wire and_in = x & ~ff_and;
    wire or_in = x | ~ff_or;

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        ff_xor <= xor_in;
        ff_and <= and_in;
        ff_or <= or_in;
    end

    // Output logic - 3-input NOR gate
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule