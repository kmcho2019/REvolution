module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire partial_carry = a & b;
    
    assign sum = a ^ b ^ cin;
    assign cout = partial_carry | ((a ^ b) & cin);
endmodule