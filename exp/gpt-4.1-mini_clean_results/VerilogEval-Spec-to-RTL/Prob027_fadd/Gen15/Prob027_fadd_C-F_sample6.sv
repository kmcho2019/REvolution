module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Direct full adder logic: sum = a ^ b ^ cin
    assign sum = a ^ b ^ cin;
    // carry-out = majority of (a,b,cin) = (a&b) | (b&cin) | (cin&a)
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule