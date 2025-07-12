module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Optimal full adder implementation:
    // sum = XOR of all inputs (a ^ b ^ cin)
    // cout = majority function (OR of all input pairs)
    assign {cout, sum} = {(a & b) | (a & cin) | (b & cin), a ^ b ^ cin};
endmodule