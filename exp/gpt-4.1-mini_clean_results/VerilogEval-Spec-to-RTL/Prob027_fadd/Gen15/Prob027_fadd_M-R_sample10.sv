module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Direct Boolean expressions for sum and carry-out
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule