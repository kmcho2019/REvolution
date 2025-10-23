module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct behavioral implementation of AND function
    assign q = a & b;
endmodule