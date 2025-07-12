module TopModule (
    input  clk,
    input  x,
    output z
);

    // Flip-flop outputs
    reg q_xor;
    reg q_and;
    reg q_or;

    // Initialize flip-flops to zero as per problem statement
    initial begin
        q_xor = 1'b0;
        q_and = 1'b0;
        q_or  = 1'b0;
    end

    // Compute D inputs for each flip-flop according to the problem logic
    wire d_xor = x ^ q_xor;     // XOR with q_xor (non-complemented)
    wire d_and = x & (~q_and);  // AND with complemented q_and
    wire d_or  = x | (~q_or);   // OR with complemented q_or

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output z is the NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule