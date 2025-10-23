// Full Adder Module
module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Direct and efficient calculation of sum and carry-out
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule