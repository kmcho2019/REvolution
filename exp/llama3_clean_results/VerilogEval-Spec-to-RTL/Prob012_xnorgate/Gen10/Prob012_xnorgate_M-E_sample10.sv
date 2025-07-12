module TopModule(
    input  a,
    input  b,
    output out
);

    // Directly compute the XNOR result by inverting the XOR of a and b
    assign out = ~(a ^ b);

endmodule