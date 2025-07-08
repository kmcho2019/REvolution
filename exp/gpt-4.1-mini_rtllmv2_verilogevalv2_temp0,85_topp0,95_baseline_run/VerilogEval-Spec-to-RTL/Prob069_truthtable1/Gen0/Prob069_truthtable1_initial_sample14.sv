module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);
    // From the truth table, f=1 for:
    // (x3,x2,x1) = 0,1,0; 0,1,1; 1,0,1; 1,1,1
    // Minterms: 
    // m2: !x3 & x2 & !x1
    // m3: !x3 & x2 & x1
    // m5: x3 & !x2 & x1
    // m7: x3 & x2 & x1
    // Expression: (!x3 & x2) | (x3 & x1)
    assign f = (!x3 & x2) | (x3 & x1);

endmodule