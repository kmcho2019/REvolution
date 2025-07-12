module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum is the parity of all three inputs
    assign sum = a ^ b ^ cin;
    
    // Carry-out is the majority function
    assign cout = (a & b) | (cin & (a ^ b));
endmodule