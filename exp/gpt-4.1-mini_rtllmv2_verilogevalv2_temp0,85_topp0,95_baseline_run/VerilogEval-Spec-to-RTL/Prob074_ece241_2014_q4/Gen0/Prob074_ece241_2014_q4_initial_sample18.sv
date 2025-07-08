module TopModule (
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    wire d_xor, d_and, d_or;

    // Inputs to gates:
    // XOR: x and q_xor
    assign d_xor = x ^ q_xor;
    // AND: x and ~q_and
    assign d_and = x & (~q_and);
    // OR: x or ~q_or
    assign d_or = x | (~q_or);

    // Sequential logic: flip-flops triggered on posedge clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output is NOR of all three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

    // Initialize flip-flops to zero at simulation start
    initial begin
        q_xor = 0;
        q_and = 0;
        q_or  = 0;
    end

endmodule