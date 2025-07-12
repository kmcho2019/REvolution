module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor, q_and, q_or;
    reg d_xor, d_and, d_or;

    // Combinational logic for D inputs
    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & (~q_and);
        d_or  = x | (~q_or);
    end

    // Sequential logic: update flip-flops on positive edge of clk
    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Output: NOR of flip-flop outputs
    assign z = ~(q_xor | q_and | q_or);

endmodule