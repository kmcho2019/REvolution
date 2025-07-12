module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire majority = (a & b) | (a & cin) | (b & cin);
    
    assign sum = majority ? ~(a ^ b ^ cin) : (a ^ b ^ cin);
    assign cout = majority;
endmodule