module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

    // The sum of a full adder is the XOR of the three inputs
    assign sum = a ^ b ^ cin;
    
    // The carry-out occurs when at least two of the inputs are high (1)
    // This can be represented as (a AND b) OR (a AND cin) OR (b AND cin)
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule