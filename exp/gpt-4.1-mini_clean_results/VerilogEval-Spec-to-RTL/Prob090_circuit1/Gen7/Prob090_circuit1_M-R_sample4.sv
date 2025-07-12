module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign the AND of inputs to output q
    assign q = a & b;
endmodule