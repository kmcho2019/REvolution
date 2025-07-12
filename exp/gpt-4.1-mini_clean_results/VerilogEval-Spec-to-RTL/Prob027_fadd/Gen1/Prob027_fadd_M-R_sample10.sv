module TopModule(
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
    wire ab_xor;
    wire ab_and;
    wire cin_and_abxor;

    assign ab_xor = a ^ b;
    assign ab_and = a & b;
    assign cin_and_abxor = cin & ab_xor;

    assign sum = ab_xor ^ cin;
    assign cout = ab_and | cin_and_abxor;
endmodule