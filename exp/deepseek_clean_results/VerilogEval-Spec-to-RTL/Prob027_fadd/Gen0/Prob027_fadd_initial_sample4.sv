module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum is the XOR of all three inputs
    assign sum = a ^ b ^ cin;
    
    // Carry-out is 1 if at least two inputs are 1
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule