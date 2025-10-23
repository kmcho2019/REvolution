module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output wire q
);

    assign q = b | c;

endmodule