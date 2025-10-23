module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b;
    wire a_and_b;
    wire a_and_cin;
    wire b_and_cin;
    
    assign a_xor_b = a ^ b;
    assign sum = a_xor_b ^ cin;
    
    assign a_and_b = a & b;
    assign a_and_cin = a & cin;
    assign b_and_cin = b & cin;
    assign cout = a_and_b | a_and_cin | b_and_cin;
endmodule