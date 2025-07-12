module TopModule (
    input  a,
    input  b,
    output q
);
    // Using technology-mapped minimal implementation
    assign q = a & b;  // Synthesis tool will pick optimal AND implementation
    
    // Alternative implementation that might be more efficient in some technologies:
    // wire nand_out;
    // assign nand_out = ~(a & b);
    // assign q = ~nand_out;
endmodule