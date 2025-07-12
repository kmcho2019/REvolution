module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

// Continuous assignment for combinational logic
assign sum = a ^ b ^ cin; // XOR operation for sum
assign cout = (a & b) | (a & cin) | (b & cin); // Majority logic for carry-out

endmodule