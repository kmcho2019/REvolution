module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg ff_xor = 0, ff_and = 0, ff_or = 0;

    // Three-input NOR gate for final output
    assign z = ~(ff_xor | ff_and | ff_or);

    // Flip-flops with direct gate assignments
    always @(posedge clk) begin
        ff_xor <= x ^ ff_xor;        // XOR with non-complemented output
        ff_and <= x & (~ff_and);     // AND with complemented output
        ff_or  <= x | (~ff_or);      // OR with complemented output
    end

endmodule