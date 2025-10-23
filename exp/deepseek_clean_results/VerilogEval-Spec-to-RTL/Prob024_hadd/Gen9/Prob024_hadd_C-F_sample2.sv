module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    assign sum = a ^ b;  // Optimal XOR implementation
    assign cout = a & b; // Optimal AND implementation
endmodule