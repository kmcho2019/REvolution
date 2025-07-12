module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum calculation remains the same (optimal)
    assign sum = a ^ b ^ cin;
    
    // Alternative carry calculation using majority function
    assign cout = (a & b) | (b & cin) | (cin & a);
endmodule