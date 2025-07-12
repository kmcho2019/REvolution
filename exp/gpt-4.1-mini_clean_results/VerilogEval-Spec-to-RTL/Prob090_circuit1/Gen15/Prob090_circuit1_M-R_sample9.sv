module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct continuous assignment implements AND function
    assign q = a & b;
endmodule