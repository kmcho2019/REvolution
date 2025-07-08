module TopModule (
    input  a,
    input  b,
    output sum,
    output cout
);
    assign sum = a ^ b;    // sum is XOR of a and b
    assign cout = a & b;   // carry out is AND of a and b
endmodule