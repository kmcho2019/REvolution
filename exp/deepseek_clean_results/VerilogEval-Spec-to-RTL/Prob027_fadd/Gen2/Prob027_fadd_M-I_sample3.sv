module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);

    // Direct implementation for sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);

endmodule