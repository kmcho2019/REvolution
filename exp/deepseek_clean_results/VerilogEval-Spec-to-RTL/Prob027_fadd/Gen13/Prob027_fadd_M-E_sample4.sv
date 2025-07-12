module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Majority function for carry-out
    assign cout = (a & b) | (a & cin) | (b & cin);
    
    // 3-input XOR for sum (parity)
    assign sum = a ^ b ^ cin;
endmodule