module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Inverting the result of XOR operation to get XNOR

endmodule