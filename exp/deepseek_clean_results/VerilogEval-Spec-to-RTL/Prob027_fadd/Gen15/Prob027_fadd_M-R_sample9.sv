module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;
    
    // Carry-out is majority function (at least two 1s)
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule