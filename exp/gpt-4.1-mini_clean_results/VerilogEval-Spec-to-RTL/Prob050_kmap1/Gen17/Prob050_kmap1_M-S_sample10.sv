module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire not_b, not_c;

    assign not_b = ~b;
    assign not_c = ~c;
    assign out = (b | c) | (not_b & not_c & a);
endmodule