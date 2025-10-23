module TopModule(
    input  a,
    input  b,
    output q
);
    // Output q is asserted only when both inputs a and b are high.
    // Implemented as a combinational AND gate using continuous assignment.
    assign q = a & b;
endmodule