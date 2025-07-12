module TopModule(
    input clk,
    input x,
    output z
);

    reg q_xor, q_and, q_or;

    wire d_xor, d_and, d_or;

    // Compute D inputs for the flip-flops
    assign d_xor = x ^ q_xor;
    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    // Update flip-flops on positive clock edge, reset to zero initially
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is NOR of all three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule