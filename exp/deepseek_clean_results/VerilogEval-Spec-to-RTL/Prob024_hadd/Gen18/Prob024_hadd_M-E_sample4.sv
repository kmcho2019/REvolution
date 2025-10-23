module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum is the parity (XOR) of inputs
    assign sum = a ^ b;
    
    // Carry is the majority function (AND) of inputs
    assign cout = a & b;
endmodule