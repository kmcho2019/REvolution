module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire ab_xor;
    
    assign ab_xor = a ^ b;
    assign sum = ab_xor ^ cin;
    assign cout = ab_xor ? cin : a;
endmodule