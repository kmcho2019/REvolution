module TopModule(
    input a,
    input b,
    output out
);
    wire w1, w2;
    
    // Implement NOR using NAND gates (De Morgan's Law)
    nand(w1, a, a);  // NOT a
    nand(w2, b, b);  // NOT b
    nand(out, w1, w2);  // NAND of NOT a and NOT b = NOR(a,b)
endmodule