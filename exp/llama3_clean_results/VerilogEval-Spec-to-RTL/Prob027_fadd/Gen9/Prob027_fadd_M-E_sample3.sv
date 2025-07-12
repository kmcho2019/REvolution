module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// K-map derived Boolean equations for sum and carry-out
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule