module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b = a ^ b;
    wire a_and_b = a & b;
    
    assign sum = a_xor_b ^ cin;
    assign cout = a_and_b | (a_xor_b & cin);
endmodule