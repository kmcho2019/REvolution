module TopModule (
    input  clk,
    input  rst,   // synchronous reset, active high
    input  x,
    output z
);

    // Flip-flop outputs as registers
    reg q_xor, q_and, q_or;

    // Combinational logic for D inputs of flip-flops
    wire d_xor = x ^ q_xor;
    wire d_and = x & (~q_and);
    wire d_or  = x | (~q_or);

    // Flip-flops update on positive edge of clk with synchronous reset
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

    // Output z is NOR of the flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule