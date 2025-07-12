module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b, a_and_b, a_xor_b_and_cin;
    
    assign a_xor_b = a ^ b;
    assign a_and_b = a & b;
    assign a_xor_b_and_cin = a_xor_b & cin;
    
    assign sum = a_xor_b ^ cin;
    assign cout = a_and_b | a_xor_b_and_cin;
endmodule