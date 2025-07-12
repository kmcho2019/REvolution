module TopModule (
    input  clk,
    input  x,
    output z
);

    // Flip-flop outputs representing the state
    reg ff_xor, ff_and, ff_or;

    // Initialize flip-flops to zero at start (for simulation and synthesis)
    initial begin
        ff_xor = 1'b0;
        ff_and = 1'b0;
        ff_or  = 1'b0;
    end

    // Combinational signals for D inputs to the flip-flops
    wire d_xor, d_and, d_or;

    // XOR flip-flop input: x XOR current output
    assign d_xor = x ^ ff_xor;

    // AND flip-flop input: x AND complement of current output
    assign d_and = x & (~ff_and);

    // OR flip-flop input: x OR complement of current output
    assign d_or = x | (~ff_or);

    // Sequential logic: flip-flops update on posedge clk
    always @(posedge clk) begin
        ff_xor <= d_xor;
        ff_and <= d_and;
        ff_or  <= d_or;
    end

    // Output z is NOR of flip-flop outputs
    assign z = ~(ff_xor | ff_and | ff_or);

endmodule