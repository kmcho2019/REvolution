module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

    // Implement sum using XOR gate
    assign sum = a ^ b;
    
    // Implement carry-out using AND gate
    assign cout = a & b;

endmodule