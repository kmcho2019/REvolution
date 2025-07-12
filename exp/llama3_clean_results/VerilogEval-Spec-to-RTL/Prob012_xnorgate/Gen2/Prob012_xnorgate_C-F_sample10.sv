module TopModule(
    input  a,
    input  b,
    output out
);
    
    // Directly implementing XNOR using XOR and inversion for simplicity and efficiency
    assign out = ~(a ^ b);

endmodule