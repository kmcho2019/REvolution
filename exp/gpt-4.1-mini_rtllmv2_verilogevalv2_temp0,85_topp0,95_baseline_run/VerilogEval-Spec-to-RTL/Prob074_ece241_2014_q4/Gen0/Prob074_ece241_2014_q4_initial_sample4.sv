module TopModule (
    input  clk,
    input  x,
    output z
);

    reg dff_xor, dff_and, dff_or;

    wire xor_in, and_in, or_in;

    // XOR gate: inputs are x and flip-flop output (dff_xor)
    assign xor_in = x ^ dff_xor;

    // AND gate: inputs are x and complement of flip-flop output (~dff_and)
    assign and_in = x & (~dff_and);

    // OR gate: inputs are x and complement of flip-flop output (~dff_or)
    assign or_in  = x | (~dff_or);

    // NOR gate combining all three flip-flop outputs to produce z
    assign z = ~(dff_xor | dff_and | dff_or);

    // D flip-flops updating on positive clock edge, initialized to zero
    always @(posedge clk) begin
        dff_xor <= xor_in;
        dff_and <= and_in;
        dff_or  <= or_in;
    end

    // Initialize flip-flops to zero at simulation start (synthesis tools may handle reset differently)
    initial begin
        dff_xor = 0;
        dff_and = 0;
        dff_or  = 0;
    end

endmodule