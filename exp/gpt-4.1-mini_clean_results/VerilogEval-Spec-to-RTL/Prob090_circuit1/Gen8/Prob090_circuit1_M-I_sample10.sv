module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign AND function to output
    assign q = a & b;
endmodule