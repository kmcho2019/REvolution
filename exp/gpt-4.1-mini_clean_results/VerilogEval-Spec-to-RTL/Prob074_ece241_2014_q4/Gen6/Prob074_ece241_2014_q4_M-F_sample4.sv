module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop state registers, initialized to zero
    reg q_xor = 1'b0, q_and = 1'b0, q_or = 1'b0;

    // D inputs for the flip-flops based on the problem description
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Sequential logic: update flip-flops on positive edge of clock
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is the NOR of all three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule