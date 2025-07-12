module TopModule (
    input  a,
    input  b,
    output q
);
    // Output q is high only when both inputs a and b are high.
    // Implements a combinational AND gate.
    assign q = a & b;
endmodule