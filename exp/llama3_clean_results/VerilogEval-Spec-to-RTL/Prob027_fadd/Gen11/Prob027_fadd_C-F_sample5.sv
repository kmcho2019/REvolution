module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

// Direct implementation with basic logic gates
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);

endmodule