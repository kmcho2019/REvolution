module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire ab_and = a & b;
    wire ab_xor = a ^ b;
    
    assign sum = ab_xor ^ cin;
    assign cout = ab_and | (ab_xor & cin);
endmodule