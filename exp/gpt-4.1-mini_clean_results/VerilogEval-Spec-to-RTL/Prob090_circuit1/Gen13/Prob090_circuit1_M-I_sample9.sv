module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct continuous assignment of AND function without extra module instantiation
    assign q = a & b;
endmodule