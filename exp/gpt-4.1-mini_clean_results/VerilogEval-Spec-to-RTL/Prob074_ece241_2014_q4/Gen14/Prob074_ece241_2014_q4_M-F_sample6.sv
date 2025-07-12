module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal asynchronous power-on reset signal, initialized to 1
    reg internal_reset = 1'b1;

    // Flip-flops storing the state, with asynchronous reset
    reg q_xor, q_and, q_or;

    // Compute D inputs for the flip-flops according to problem logic
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Clear internal_reset synchronously after first clock edge
    always @(posedge clk) begin
        internal_reset <= 1'b0;
    end

    // Flip-flops update on posedge clk with asynchronous reset (active high)
    always @(posedge clk or posedge internal_reset) begin
        if (internal_reset) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is NOR of all flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule