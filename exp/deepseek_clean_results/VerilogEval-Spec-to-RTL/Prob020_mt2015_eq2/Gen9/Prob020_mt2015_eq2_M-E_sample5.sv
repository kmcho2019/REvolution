module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Bitwise equality check using XNOR and reduction AND
    wire [1:0] bit_eq;
    
    assign bit_eq = A ~^ B;  // Bitwise XNOR (equality check)
    assign z = &bit_eq;      // Reduction AND (all bits equal)
endmodule