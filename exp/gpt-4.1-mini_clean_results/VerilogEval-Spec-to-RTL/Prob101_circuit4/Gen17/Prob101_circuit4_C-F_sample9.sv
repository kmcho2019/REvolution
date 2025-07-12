module TopModule(
    input  wire a,  // Unused input
    input  wire b,
    input  wire c,
    input  wire d,  // Unused input
    output wire q
);
    // Output q is high when either b or c is high, independent of a and d.
    assign q = b | c;
endmodule