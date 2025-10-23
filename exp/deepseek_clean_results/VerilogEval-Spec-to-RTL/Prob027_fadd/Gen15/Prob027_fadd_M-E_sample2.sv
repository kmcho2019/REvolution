module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Carry is majority of a, b, cin
    assign cout = (a & b) | (a & cin) | (b & cin);
    
    // Sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;
endmodule