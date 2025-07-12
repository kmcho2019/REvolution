module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum is parity of all inputs
    assign sum = a ^ b ^ cin;
    
    // Carry is majority function (OR of all pairwise ANDs)
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule