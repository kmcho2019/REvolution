module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

wire na = ~a;
wire nb = ~b;

always @(*) begin
    // Intermediate terms
    reg term1, term2, term3;
    term1 = (~d) & na;
    term2 = (~c) & nb;
    term3 = c & d & (a | b);
    out = term1 | term2 | term3;
end

endmodule