module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    wire a_nand_b, a_nand_notb, notb;
    
    // Compute intermediate signals using only NANDs
    assign a_nand_b = ~(a & b);
    assign notb = ~(b & b);  // NAND-based inverter
    assign a_nand_notb = ~(a & notb);
    
    // Sum output via MUX-like selection
    assign sum = (b) ? a_nand_notb : ~a_nand_b;
    
    // Carry output using optimized NAND-NOR combination
    assign cout = ~(a_nand_b & a_nand_b);  // Equivalent to AND

endmodule