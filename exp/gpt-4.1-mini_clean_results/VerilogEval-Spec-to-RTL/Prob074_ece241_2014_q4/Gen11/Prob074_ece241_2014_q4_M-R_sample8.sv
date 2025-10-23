module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal synchronous reset signal, high for one cycle after start
    reg reset;
    initial reset = 1'b1;

    always @(posedge clk) begin
        if (reset)
            reset <= 1'b0;  // Deassert reset after first clock
    end

    // Flip-flop outputs as registers
    reg q_xor, q_and, q_or;

    // Combinational logic for D inputs of flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops with synchronous reset on positive edge of clk
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

    // Output z is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule