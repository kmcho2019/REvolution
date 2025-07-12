module TopModule(
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    wire d_xor, d_and, d_or;

    // XOR gate input: x and q_xor
    assign d_xor = x ^ q_xor;

    // AND gate input: x and complemented q_and
    assign d_and = x & (~q_and);

    // OR gate input: x or complemented q_or
    assign d_or = x | (~q_or);

    // Sequential logic: update flip-flops on posedge clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule