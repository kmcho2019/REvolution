module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Carry-out using majority function
    assign cout = (a & b) | (a & cin) | (b & cin);
    
    // Sum using 3-input XOR
    assign sum = a ^ b ^ cin;
endmodule