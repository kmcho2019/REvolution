module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct continuous assignment implementing AND operation
    assign q = a & b;
endmodule