module TopModule (
    input  clk,
    input  rst, // synchronous reset added to initialize flip-flops to zero
    input  x,
    output z
);

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Wires for complemented flip-flop outputs
    wire nq_and, nq_or;

    // D inputs for flip-flops
    reg d_xor, d_and, d_or;

    // Complement signals
    assign nq_and = ~q_and;
    assign nq_or  = ~q_or;

    // Compute D inputs combinationally
    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & nq_and;
        d_or  = x | nq_or;
    end

    // Sequential flip-flops with synchronous reset
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