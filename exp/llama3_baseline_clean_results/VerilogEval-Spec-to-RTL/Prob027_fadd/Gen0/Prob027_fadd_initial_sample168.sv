module TopModule(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

assign sum = a ^ b ^ cin;  // XOR operation for sum
assign cout = (a & b) | (a & cin) | (b & cin);  // OR and AND operations for carry-out

endmodule