module TopModule (
    input wire a,
    input wire b,
    output wire q
);
    // Direct continuous assignment
    assign q = a & b;
endmodule