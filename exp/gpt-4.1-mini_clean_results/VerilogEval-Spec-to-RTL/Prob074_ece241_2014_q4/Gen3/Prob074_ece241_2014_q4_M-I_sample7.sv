module TopModule (
    input  clk,
    input  x,
    output z
);
    reg q_xor, q_and, q_or;
    reg reset_internal;

    // Internal synchronous reset logic:
    // Initially assert reset_internal, then deassert after first clock edge.
    initial reset_internal = 1'b1;

    always @(posedge clk) begin
        if (reset_internal)
            reset_internal <= 1'b0;

        if (reset_internal) begin
            // Synchronously reset flip-flops to zero on first clock cycle
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= x ^ q_xor;
            q_and <= x & ~q_and;
            q_or  <= x | ~q_or;
        end
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule