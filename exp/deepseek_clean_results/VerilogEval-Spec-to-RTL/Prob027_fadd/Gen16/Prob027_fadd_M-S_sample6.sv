module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b = a ^ b;
    
    assign sum = a_xor_b ^ cin;
    assign cout = (a & b) | (cin & a_xor_b);
endmodule