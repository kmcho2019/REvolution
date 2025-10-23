module TopModule (
    input  clk,
    input  reset,  // synchronous active-high reset input
    input  x,
    output z
);

    // Registered outputs
    reg q_xor, q_and, q_or;

    // Combinational logic for D inputs
    wire d_xor, d_and, d_or;

    assign d_xor = x ^ q_xor;
    assign d_and = x & ~q_and;
    assign d_or  = x | ~q_or;

    // Sequential logic: D flip-flops with synchronous reset
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

    // Output logic: NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule