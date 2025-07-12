module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire partial_sum, partial_carry;
    
    // First stage: add a and b
    assign partial_sum = a ^ b;
    assign partial_carry = a & b;
    
    // Second stage: incorporate cin
    assign sum = partial_sum ^ cin;
    assign cout = partial_carry | (partial_sum & cin);
endmodule