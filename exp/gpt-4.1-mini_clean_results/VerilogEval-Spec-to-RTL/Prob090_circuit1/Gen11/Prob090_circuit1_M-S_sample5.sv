module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign q as the AND of inputs a and b
    assign q = a & b;
endmodule