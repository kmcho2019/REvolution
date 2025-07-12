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

    assign out = (c == 0 && d == 0) ? ab :
                 (c == 0 && d == 1) ? ~ab :
                 (c == 1 && d == 1) ? ab :
                 (c == 1 && d == 0) ? ~ab;

endmodule