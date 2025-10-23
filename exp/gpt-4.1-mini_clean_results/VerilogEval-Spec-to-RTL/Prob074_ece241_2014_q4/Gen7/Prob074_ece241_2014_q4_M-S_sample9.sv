module TopModule (
    input  clk,
    input  x,
    output z
);

    reg q_xor, q_and, q_or;

    wire d_xor = x ^ q_xor;
    wire d_and = x & ~q_and;
    wire d_or  = x | ~q_or;

    always @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    assign z = ~(q_xor | q_and | q_or);

endmodule