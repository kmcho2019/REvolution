module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);
    // Direct continuous assignment to minimize area and power
    assign out = a | b | c;
endmodule