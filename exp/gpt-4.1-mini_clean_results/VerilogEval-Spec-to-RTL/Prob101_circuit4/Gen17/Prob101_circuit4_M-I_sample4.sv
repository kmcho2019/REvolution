module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Direct continuous assignment for minimal combinational logic
    assign q = b | c;
endmodule