module TopModule(
    input  a,
    input  b,
    output out
);

    // Directly compute the out signal using the XNOR property
    assign out = ~(a ^ b);

endmodule