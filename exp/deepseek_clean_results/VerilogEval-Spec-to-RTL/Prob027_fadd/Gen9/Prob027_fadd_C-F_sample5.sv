module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire partial_sum = a ^ b;
    wire partial_carry = a & b;
    
    assign sum = partial_sum ^ cin;
    assign cout = partial_carry | (partial_sum & cin);
endmodule