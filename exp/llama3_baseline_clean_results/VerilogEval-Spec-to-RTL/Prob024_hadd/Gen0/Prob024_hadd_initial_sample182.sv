module TopModule(
    input  a,
    input  b,
    output sum,
    output cout
);

    // Calculate sum using XOR
    assign sum = a ^ b;
    
    // Calculate carry-out using AND
    assign cout = a & b;

endmodule