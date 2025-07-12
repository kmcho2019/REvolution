module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire ab_xor = a ^ b;
    
    assign sum = ab_xor ^ cin;
    assign cout = (a & b) | (ab_xor & cin);
endmodule