module TopModule (
    input clk,
    input rst_n,   // Active-low asynchronous reset
    input x,
    output z
);

    // Current state registers for each flip-flop
    reg q_xor, q_and, q_or;

    // Next state signals (combinational)
    wire d_xor, d_and, d_or;

    // Combinational logic for next states
    assign d_xor = x ^ q_xor;
    assign d_and = x & (~q_and);
    assign d_or  = x | (~q_or);

    // Sequential logic with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule