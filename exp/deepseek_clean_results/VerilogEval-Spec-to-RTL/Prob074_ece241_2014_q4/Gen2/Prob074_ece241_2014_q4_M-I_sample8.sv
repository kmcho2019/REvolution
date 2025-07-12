module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or = 1'b0;

    // Continuous assignments for combinational logic
    wire d_xor = x ^ q_xor;          // XOR feedback
    wire d_and = x & ~q_and;         // AND with complemented feedback
    wire d_or = x | ~q_or;           // OR with complemented feedback

    // Final NOR output assigned directly to output port
    assign z = ~(q_xor | q_and | q_or);

    // Flip-flop updates (positive edge triggered)
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or <= d_or;
    end

endmodule