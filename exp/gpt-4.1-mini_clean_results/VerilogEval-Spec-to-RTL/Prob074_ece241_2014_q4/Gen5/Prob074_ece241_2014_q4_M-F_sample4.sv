module TopModule (
    input  clk,
    input  x,
    output z
);

    // Flip-flop state registers initialized to zero
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    // Combinational signals for gate outputs feeding the D inputs of flip-flops
    wire d_xor, d_and, d_or;

    // Compute combinational logic outside always block
    assign d_xor = x ^ q_xor;      // XOR gate: x and q_xor
    assign d_and = x & (~q_and);   // AND gate: x and complement of q_and
    assign d_or  = x | (~q_or);    // OR gate: x and complement of q_or

    // Sequential logic: flip-flops updated on rising edge of clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is the NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule