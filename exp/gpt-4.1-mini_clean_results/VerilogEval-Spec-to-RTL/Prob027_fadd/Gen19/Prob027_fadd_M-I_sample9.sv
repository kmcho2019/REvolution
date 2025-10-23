module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    // Direct combinational logic implementing full adder sum and carry
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule