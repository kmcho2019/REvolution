module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal synchronous reset signal, asserted only on first clock cycle after power-up
    reg rst_sync = 1'b1;

    // Deassert reset after first clock edge
    always @(posedge clk) begin
        if (rst_sync)
            rst_sync <= 1'b0;
    end

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Next state logic for each flip-flop input
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops with synchronous reset
    always @(posedge clk) begin
        if (rst_sync) begin
            q_xor <= 1'b0;
            q_and <= 1'b0;
            q_or  <= 1'b0;
        end else begin
            q_xor <= d_xor;
            q_and <= d_and;
            q_or  <= d_or;
        end
    end

    // Output z is NOR of the three flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule