module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum is the XOR of all three inputs
    assign sum = a ^ b ^ cin;
    
    // Carry-out is the majority function of the three inputs
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule