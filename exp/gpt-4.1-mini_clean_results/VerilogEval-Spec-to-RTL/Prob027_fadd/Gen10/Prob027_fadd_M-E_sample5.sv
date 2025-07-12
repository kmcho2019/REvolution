module TopModule (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire axb; // a XOR b

    assign axb = a ^ b;
    assign sum = axb ^ cin;
    // cout = (a AND b) OR (cin AND (a XOR b))
    assign cout = (a & b) | (cin & axb);

endmodule