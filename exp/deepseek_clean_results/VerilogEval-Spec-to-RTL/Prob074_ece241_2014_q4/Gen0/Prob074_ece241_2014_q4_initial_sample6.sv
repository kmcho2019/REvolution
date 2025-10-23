module TopModule (
    input clk,
    input x,
    output z
);

    // Declare flip-flop outputs
    reg q_xor, q_and, q_or;

    // XOR path: x XOR q_xor
    wire d_xor = x ^ q_xor;

    // AND path: x AND ~q_and
    wire d_and = x & ~q_and;

    // OR path: x OR ~q_or
    wire d_or = x | ~q_or;

    // Three D flip-flops with synchronous reset (initially 0)
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or <= d_or;
    end

    // Three-input NOR gate for output z
    assign z = ~(q_xor | q_and | q_or);

endmodule