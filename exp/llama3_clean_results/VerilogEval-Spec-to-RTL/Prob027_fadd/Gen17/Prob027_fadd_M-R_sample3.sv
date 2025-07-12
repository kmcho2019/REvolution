// Refactored TopModule
module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Direct continuous assignments for sum and cout
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule