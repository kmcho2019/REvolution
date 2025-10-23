module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign the AND of inputs to output for minimal area and power
    assign q = a & b;
endmodule