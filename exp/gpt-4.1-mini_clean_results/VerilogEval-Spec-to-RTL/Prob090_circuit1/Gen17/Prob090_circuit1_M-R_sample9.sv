module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Directly assign q to the AND of inputs a and b using bitwise AND operator
    assign q = a & b;
endmodule