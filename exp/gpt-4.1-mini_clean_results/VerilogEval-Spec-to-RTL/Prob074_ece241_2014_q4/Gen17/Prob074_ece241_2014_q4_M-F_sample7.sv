module TopModule (
    input clk,
    input x,
    output z
);

    // Separate flip-flop outputs
    reg q_xor, q_and, q_or;

    // Combinational next-state signals
    wire d_xor, d_and, d_or;

    // Initialize flip-flops to zero at simulation start
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    // Compute D inputs based on current flip-flop outputs and input x
    assign d_xor = x ^ q_xor;
    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    // Update flip-flops on positive edge of clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is NOR of all three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule