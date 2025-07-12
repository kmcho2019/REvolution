module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // Invert the result of the XOR operation to get XNOR

endmodule