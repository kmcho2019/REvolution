module TopModule (
    input  clk,
    input  x,
    output z
);

    reg ff_xor, ff_and, ff_or;

    // Combinational wires for gate outputs
    wire xor_out = x ^ ff_xor;
    wire and_out = x & ~ff_and;
    wire or_out  = x | ~ff_or;

    // Flip-flops updated with gate outputs at clock positive edge
    always @(posedge clk) begin
        ff_xor <= xor_out;
        ff_and <= and_out;
        ff_or  <= or_out;
    end

    // Output is NOR of all three flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

    // Initial flip-flop state zero for simulation
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

endmodule