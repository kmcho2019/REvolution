module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Direct continuous assignment implementing the logic function from the K-map
    assign out = a | b | c;
endmodule