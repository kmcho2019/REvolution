module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor = 1'b0;
    reg q_and = 1'b0;
    reg q_or  = 1'b0;

    // Compute D inputs for each flip-flop according to the problem description
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flop for XOR path
    always @(posedge clk) begin
        q_xor <= d_xor;
    end

    // Flip-flop for AND path
    always @(posedge clk) begin
        q_and <= d_and;
    end

    // Flip-flop for OR path
    always @(posedge clk) begin
        q_or <= d_or;
    end

    // Output is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule