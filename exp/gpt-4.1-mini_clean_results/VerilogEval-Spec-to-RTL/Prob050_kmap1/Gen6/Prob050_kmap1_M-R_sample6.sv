module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire not_b = ~b;
    wire not_c = ~c;

    // out = (b | c) | (not_b & not_c & a)
    assign out = (b | c) | (not_b & not_c & a);

endmodule