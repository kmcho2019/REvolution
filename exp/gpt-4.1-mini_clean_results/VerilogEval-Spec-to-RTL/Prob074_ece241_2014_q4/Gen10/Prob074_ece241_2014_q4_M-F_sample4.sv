module TopModule (
    input  clk,
    input  rst,  // Added synchronous reset input
    input  x,
    output z
);

    reg q_xor;
    reg q_and;
    reg q_or;

    wire d_xor;
    wire d_and;
    wire d_or;

    // Compute the D inputs using the current flip-flop outputs and input x
    assign d_xor = x ^ q_xor;
    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    always @(posedge clk) begin
        if (rst) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule