module TopModule(
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    // Initialize flip-flops to zero
    initial begin
        q_xor = 0;
        q_and = 0;
        q_or = 0;
    end

    wire d_xor, d_and, d_or;

    // Calculate D inputs according to the problem statement
    assign d_xor = x ^ q_xor;
    assign d_and = x & ~q_and;
    assign d_or  = x | ~q_or;

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule