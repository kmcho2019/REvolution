module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Intermediate terms
    wire a_xor_b = a ^ b;
    wire a_and_b = a & b;
    wire ab_xor_cin = a_xor_b & cin;
    
    // Sum as parity of all inputs
    assign sum = a_xor_b ^ cin;
    
    // Carry-out as majority function (optimized implementation)
    assign cout = a_and_b | ab_xor_cin;
endmodule