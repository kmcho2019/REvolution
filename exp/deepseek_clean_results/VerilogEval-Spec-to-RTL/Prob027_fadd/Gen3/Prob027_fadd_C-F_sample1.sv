module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Full adder implementation using standard equations:
    // sum = a XOR b XOR cin (odd parity function)
    // cout = majority of inputs (at least two 1's among a,b,cin)
    assign {cout, sum} = {(a & b) | (a & cin) | (b & cin), a ^ b ^ cin};
endmodule