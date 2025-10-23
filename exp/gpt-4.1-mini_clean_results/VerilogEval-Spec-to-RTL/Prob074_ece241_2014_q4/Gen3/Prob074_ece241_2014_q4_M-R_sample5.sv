module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop state registers
    reg q_xor, q_and, q_or;

    // Initialize flip-flops to zero at simulation start
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    // Sequential logic: flip-flops update on rising clock edge without reset
    always @(posedge clk) begin
        // Compute D inputs
        // XOR gate: x and current q_xor
        // AND gate: x and complement of q_and
        // OR  gate: x and complement of q_or
        q_xor <= x ^ q_xor;
        q_and <= x & (~q_and);
        q_or  <= x | (~q_or);
    end

    // Output z is the NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule