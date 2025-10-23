module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Full adder implementation with improved readability
    
    // Sum calculation: XOR of all inputs (a XOR b XOR cin)
    assign sum = a ^ b ^ cin;
    
    // Carry-out calculation: majority function
    // (a AND b) OR (a AND cin) OR (b AND cin)
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule