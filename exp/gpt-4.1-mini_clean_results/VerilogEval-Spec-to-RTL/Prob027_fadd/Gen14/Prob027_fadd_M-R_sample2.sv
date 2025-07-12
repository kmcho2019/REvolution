module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Direct continuous assignments for sum and carry-out
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule