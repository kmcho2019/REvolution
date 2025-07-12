module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Continuous assignments implementing the logic directly:
    // out = (a & b) | (c & d)
    assign out   = (a & b) | (c & d);
    assign out_n = ~out;

endmodule