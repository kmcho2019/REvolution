module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // Generate sum bit using XOR operation
    assign sum = a ^ b ^ cin;
    
    // Generate carry-out bit when at least two input bits are high
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule