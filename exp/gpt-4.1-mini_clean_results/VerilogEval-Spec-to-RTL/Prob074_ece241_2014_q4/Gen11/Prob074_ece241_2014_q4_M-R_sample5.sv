module TopModule (
    input  clk,
    input  x,
    output reg z
);

    // Internal synchronous reset signal, asserted at start, deasserted after first clock
    reg rst_n = 0;

    // State registers
    reg q_xor, q_and, q_or;

    // Internal signals for complemented outputs
    wire nq_and, nq_or;

    // D inputs for flip-flops
    reg d_xor, d_and, d_or;

    // Generate complemented signals
    assign nq_and = ~q_and;
    assign nq_or  = ~q_or;

    // Combinational logic for D inputs
    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & nq_and;
        d_or  = x | nq_or;
    end

    // Flip-flops with synchronous reset
    always @(posedge clk) begin
        if (!rst_n) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
            rst_n <= 1'b1;  // Deassert reset after first clock
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output is NOR of flip-flop outputs
    always @(*) begin
        z = ~(q_xor | q_and | q_or);
    end

endmodule