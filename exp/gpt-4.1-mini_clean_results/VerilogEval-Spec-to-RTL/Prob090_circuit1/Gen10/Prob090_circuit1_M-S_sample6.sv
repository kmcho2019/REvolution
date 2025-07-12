module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign AND of a and b to q
    assign q = a & b;
endmodule