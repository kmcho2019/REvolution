module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Implementing sum using K-map reduction
assign sum = (a ^ b ^ cin);

// Implementing carry-out using K-map reduction
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule