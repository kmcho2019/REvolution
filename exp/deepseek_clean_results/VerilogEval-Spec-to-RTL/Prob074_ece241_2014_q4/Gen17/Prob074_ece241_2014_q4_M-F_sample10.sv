module TopModule (
    input clk,
    input x,
    output z
);

    // Three independent flip-flops
    reg ff_xor = 1'b0;
    reg ff_and = 1'b0;
    reg ff_or = 1'b0;

    // Sequential logic for each flip-flop
    always @(posedge clk) begin
        ff_xor <= x ^ ff_xor;    // XOR with its own output
        ff_and <= x & ff_and;    // AND with its own output
        ff_or  <= x | ff_or;     // OR with its own output
    end

    // Output is NOR of all flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule