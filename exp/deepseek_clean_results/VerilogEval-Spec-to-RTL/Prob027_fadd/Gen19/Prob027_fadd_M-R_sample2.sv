module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire P, G;
    
    // Propagate term (a XOR b)
    assign P = a ^ b;
    
    // Generate term (a AND b)
    assign G = a & b;
    
    // Sum is P XOR cin
    assign sum = P ^ cin;
    
    // Carry is G OR (P AND cin)
    assign cout = G | (P & cin);
endmodule