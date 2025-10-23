module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab;
    wire cd;

    assign ab = a ^ b;
    assign cd = c ^ d;

    assign out = (ab & cd) | (~ab & ~cd);

endmodule