module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Direct combinational assignment for minimal area and power
    assign q = b | c;
endmodule