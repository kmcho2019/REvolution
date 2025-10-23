module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Direct implementation without intermediate wires
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | ((a ^ b) & cin);
endmodule