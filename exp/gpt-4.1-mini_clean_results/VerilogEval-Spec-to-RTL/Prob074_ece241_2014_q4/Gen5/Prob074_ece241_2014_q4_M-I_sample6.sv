module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor, q_and, q_or;
    reg reset;  // Internal synchronous reset

    // Initialize reset to 1 at start, deassert after first clock to simulate power-up reset
    initial reset = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            // Assert reset only for one clock cycle after start
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            reset <= 1'b0;  // Deassert reset next cycle
        end else begin
            // Compute next states per problem statement

            // XOR: second input is q_xor itself
            q_xor <= x ^ q_xor;

            // AND: second input is complemented q_and
            q_and <= x & (~q_and);

            // OR: second input is complemented q_or
            q_or  <= x | (~q_or);
        end
    end

    // Output is NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule