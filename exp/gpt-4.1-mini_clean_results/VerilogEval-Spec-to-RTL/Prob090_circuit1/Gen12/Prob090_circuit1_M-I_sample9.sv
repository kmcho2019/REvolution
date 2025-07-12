module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Direct assign AND function to minimize area and power
    assign q = a & b;
endmodule