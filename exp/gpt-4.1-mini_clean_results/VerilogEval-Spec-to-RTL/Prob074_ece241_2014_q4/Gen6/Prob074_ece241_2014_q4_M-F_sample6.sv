module TopModule (
    input  clk,
    input  x,
    output z
);

    // Flip-flop state registers initialized to zero at start of simulation
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    always @(posedge clk) begin
        // Update flip-flops based on input x and current states
        q_xor <= x ^ q_xor;        // XOR gate input D
        q_and <= x & (~q_and);     // AND gate input D
        q_or  <= x | (~q_or);      // OR gate input D
    end

    // Output is NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule