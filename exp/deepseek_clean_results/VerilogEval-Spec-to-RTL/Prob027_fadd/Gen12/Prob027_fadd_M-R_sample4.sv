module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b;
    wire a_and_b;
    wire cin_and_xor;
    
    assign a_xor_b = a ^ b;
    assign sum = a_xor_b ^ cin;
    
    assign a_and_b = a & b;
    assign cin_and_xor = cin & a_xor_b;
    
    assign cout = a_and_b | cin_and_xor;
endmodule