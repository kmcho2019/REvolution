module TopModule (
    input  clk,
    input  x,
    output z
);
    // Current state registers for each flip-flop
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    // Next state wires - D inputs to flip-flops
    wire d_xor;
    wire d_and;
    wire d_or;

    // Combinational logic for next state based on current state and input x
    assign d_xor = x ^ q_xor;
    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    // Flip-flops update on positive clock edge
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is the NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule