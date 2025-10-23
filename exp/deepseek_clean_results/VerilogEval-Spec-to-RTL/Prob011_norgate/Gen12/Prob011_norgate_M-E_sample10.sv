module TopModule (
    input  a,
    input  b,
    output out
);
    // Intermediate wire for the OR function implemented with NANDs
    wire or_from_nand;
    
    // First NAND implements OR function (a NAND b) = NOT (a AND b)
    // Then invert to get OR via De Morgan: NOT (NOT (a AND b)) = a AND b
    // Then invert inputs to get OR: (NOT a) NAND (NOT b) = a OR b
    nand U1 (or_from_nand, a, a);  // Invert a
    nand U2 (or_from_nand, b, b);  // Invert b
    nand U3 (or_from_nand, or_from_nand, or_from_nand);  // OR function
    
    // Second NAND implements the final inversion for NOR
    nand U4 (out, or_from_nand, or_from_nand);
endmodule