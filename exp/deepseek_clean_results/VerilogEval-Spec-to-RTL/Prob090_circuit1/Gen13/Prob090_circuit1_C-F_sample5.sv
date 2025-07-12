module TopModule (
    input  a,
    input  b,
    output q  // Explicit wire (optional but clear)
);
    // Simple AND operation with continuous assignment
    assign q = a & b;
endmodule