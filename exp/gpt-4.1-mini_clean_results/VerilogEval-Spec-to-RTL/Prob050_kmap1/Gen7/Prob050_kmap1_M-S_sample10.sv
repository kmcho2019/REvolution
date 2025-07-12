module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    wire not_b = ~b;
    wire not_c = ~c;

    assign out = (b | c) | (a & not_b & not_c);
endmodule