module TopModule(
    input  a,
    input  b,
    output out
);

    // Simplified XNOR implementation using basic logical operators
    assign out = !(a ^ b);

endmodule