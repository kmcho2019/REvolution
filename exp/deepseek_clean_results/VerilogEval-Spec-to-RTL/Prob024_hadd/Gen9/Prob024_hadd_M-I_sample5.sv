module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Direct XOR implementation for sum (better PPA)
    assign sum = a ^ b;
    
    // Carry-out remains optimal AND implementation
    assign cout = a & b;
endmodule