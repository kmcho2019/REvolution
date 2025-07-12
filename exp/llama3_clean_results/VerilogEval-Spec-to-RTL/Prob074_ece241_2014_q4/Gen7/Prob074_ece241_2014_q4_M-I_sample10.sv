module TopModule(
    input clk,
    input x,
    output reg z
);

reg q_xor, q_and, q_or;

initial begin
    q_xor = 0;
    q_and = 0;
    q_or = 0;
end

always @(posedge clk) begin
    reg xor_out, and_out, or_out, next_q_xor, next_q_and, next_q_or;

    xor_out = x ^ q_xor;
    and_out = x & ~q_and;
    or_out = x | ~q_or;

    next_q_xor = xor_out;
    next_q_and = and_out;
    next_q_or = or_out;

    q_xor <= next_q_xor;
    q_and <= next_q_and;
    q_or <= next_q_or;
end

always @(*) begin
    reg xor_out, and_out, or_out;

    xor_out = x ^ q_xor;
    and_out = x & ~q_and;
    or_out = x | ~q_or;

    z = ~(xor_out | and_out | or_out);
end

endmodule