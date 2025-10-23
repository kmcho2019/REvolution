module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b;
    
    assign a_xor_b = a ^ b;
    
    // Sum logic: when cin=0, sum = a^b; when cin=1, sum = ~(a^b)
    assign sum = cin ? ~a_xor_b : a_xor_b;
    
    // Carry logic: when a=b, carry=cin; else carry=a (or b)
    assign cout = a_xor_b ? a : cin;
endmodule