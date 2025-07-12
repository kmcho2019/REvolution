module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign the output q to be the AND of a and b
    assign q = a & b;
endmodule