module HalfAdder (
    input  x,
    input  y,
    output sum,
    output cout
);
    assign sum = x ^ y;
    assign cout = x & y;
endmodule

module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Direct combinational assignments for full adder:
    // sum is XOR of all three inputs
    assign sum = a ^ b ^ cin;

    // cout is majority function of the three inputs
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule