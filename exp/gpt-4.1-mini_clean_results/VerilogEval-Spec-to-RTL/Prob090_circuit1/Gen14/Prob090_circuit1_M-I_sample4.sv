module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign AND function for minimal area and power
    assign q = a & b;
endmodule