module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Full adder sum and carry logic directly assigned
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);

endmodule