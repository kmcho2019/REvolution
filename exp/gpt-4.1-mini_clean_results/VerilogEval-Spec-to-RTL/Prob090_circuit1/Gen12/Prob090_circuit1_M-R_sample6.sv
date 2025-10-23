module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct continuous assignment of AND operation
    assign q = a & b;
endmodule