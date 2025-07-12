module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal synchronous reset signal
    reg reset = 1'b1;

    // Flip-flop outputs
    reg q_xor;
    reg q_and;
    reg q_or;

    // Deassert reset after the first clock cycle
    always @(posedge clk) begin
        if (reset)
            reset <= 1'b0;
    end

    // Compute D inputs for each flip-flop according to the problem logic
    wire d_xor = x ^ q_xor;     // XOR with q_xor (non-complemented)
    wire d_and = x & (~q_and);  // AND with complemented q_and
    wire d_or  = x | (~q_or);   // OR with complemented q_or

    // Update flip-flops on positive clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is the NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule