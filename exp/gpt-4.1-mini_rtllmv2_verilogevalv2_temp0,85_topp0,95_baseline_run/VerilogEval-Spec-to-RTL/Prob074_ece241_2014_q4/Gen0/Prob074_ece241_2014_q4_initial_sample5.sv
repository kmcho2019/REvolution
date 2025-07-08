module TopModule (
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    wire d_xor, d_and, d_or;

    // XOR gate: inputs x and q_xor
    assign d_xor = x ^ q_xor;

    // AND gate: inputs x and ~q_and
    assign d_and = x & (~q_and);

    // OR gate: inputs x and ~q_or
    assign d_or = x | (~q_or);

    // D flip-flops updated on posedge clk, initial reset to zero
    initial begin
        q_xor = 0;
        q_and = 0;
        q_or = 0;
    end

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule