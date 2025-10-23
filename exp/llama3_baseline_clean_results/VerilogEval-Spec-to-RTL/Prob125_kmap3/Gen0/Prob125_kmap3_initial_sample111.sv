module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    assign out = (c == 0 && b == 1) || (c == 1 && (a == 1 || b == 1));

endmodule