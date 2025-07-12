module TopModule (
    input  clk,
    input  reset,  // Active-high synchronous reset
    input  x,
    output z
);

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Complemented outputs for AND and OR flip-flops
    wire nq_and = ~q_and;
    wire nq_or  = ~q_or;

    // D inputs calculated from gates
    wire d_xor = x ^ q_xor;
    wire d_and = x & nq_and;
    wire d_or  = x | nq_or;

    always @(posedge clk) begin
        if (reset) begin
            // Reset flip-flops to zero synchronously
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output is NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule