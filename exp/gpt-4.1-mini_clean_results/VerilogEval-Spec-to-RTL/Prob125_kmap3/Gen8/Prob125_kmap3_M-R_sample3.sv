module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, ignored
    output reg out
);

always @(*) begin
    // Simplified terms from K-map:
    // out = (~c & a) | (c & ~b) | (c & a)
    // which equals (~c & a) | (c & (~b | a))
    reg term1, term2, term3;
    term1 = ~c & a;
    term2 = c & ~b;
    term3 = c & a;

    out = term1 | term2 | term3;
end

endmodule