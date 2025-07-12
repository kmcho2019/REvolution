module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop state registers, implicitly initialized to zero in many simulators
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    // Next-state logic calculated inside the always block for synchronous update
    always @(posedge clk) begin
        q_xor <= x ^ q_xor;      // XOR gate input: x and q_xor
        q_and <= x & (~q_and);   // AND gate input: x and complement of q_and
        q_or  <= x | (~q_or);    // OR gate input: x and complement of q_or
    end

    // Output is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule