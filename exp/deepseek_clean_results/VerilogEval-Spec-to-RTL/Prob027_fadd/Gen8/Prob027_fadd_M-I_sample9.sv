module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum calculation using single 3-input XOR (if library supports it)
    assign sum = a ^ b ^ cin;
    
    // Carry-out calculation using majority function
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule