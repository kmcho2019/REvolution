module TopModule (
    input  clk,
    input  rst,  // Synchronous reset input, active high
    input  x,
    output z
);

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Intermediate wires for complemented flip-flop outputs
    wire nq_and = ~q_and;
    wire nq_or  = ~q_or;

    // D input signals for flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & nq_and;
    wire d_or  = x | nq_or;

    // Flip-flops with synchronous reset
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

    // Output z is NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule