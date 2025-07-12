module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign output as AND of inputs
    assign q = a & b;
endmodule