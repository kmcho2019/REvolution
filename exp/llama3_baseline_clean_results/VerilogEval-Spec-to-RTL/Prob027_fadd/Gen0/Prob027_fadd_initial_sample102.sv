module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Assign sum based on the XOR of all three inputs
assign sum = a ^ b ^ cin;

// Assign carry-out based on the condition that at least two inputs are high
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule