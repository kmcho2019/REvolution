module TopModule(
    input  a,
    input  b,
    output out
);

assign out = ~(a ^ b); // The XOR operation (^) is performed first, then its result is inverted (~) to implement XNOR

endmodule