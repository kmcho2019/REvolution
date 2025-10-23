module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum is the parity (XOR) of inputs
    assign sum = (a + b) % 2;
    
    // Carry is the majority (AND) of inputs
    assign cout = a & b;
endmodule