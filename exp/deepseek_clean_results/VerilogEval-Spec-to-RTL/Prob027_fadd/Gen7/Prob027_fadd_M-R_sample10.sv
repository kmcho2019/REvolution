module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Intermediate signal for first XOR stage
    wire a_xor_b = a ^ b;
    
    // Sum calculation: a XOR b XOR cin
    assign sum = a_xor_b ^ cin;
    
    // Carry-out calculation: majority function
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule