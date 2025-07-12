module TopModule (
    input  clk,
    input  x,
    output z
);

    // Flip-flop state registers
    reg q_xor, q_and, q_or;

    // Combinational logic for the D inputs of flip-flops
    wire d_xor = x ^ q_xor;      // XOR gate: x and q_xor
    wire d_and = x & (~q_and);   // AND gate: x and complement of q_and
    wire d_or  = x | (~q_or);    // OR gate: x and complement of q_or

    // Flip-flops triggered on positive edge of clk, no reset
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule