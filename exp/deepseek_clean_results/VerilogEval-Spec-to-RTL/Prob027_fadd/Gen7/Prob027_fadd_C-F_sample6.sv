module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b = a ^ b;
    assign {cout, sum} = {(a_xor_b & cin) | (a & b), a_xor_b ^ cin};
endmodule