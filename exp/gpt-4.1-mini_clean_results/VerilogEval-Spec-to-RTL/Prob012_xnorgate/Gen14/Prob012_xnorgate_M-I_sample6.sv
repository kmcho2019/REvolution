module TopModule(
    input  a,
    input  b,
    output wire out
);
    // Explicit wire declaration for output clarity
    assign out = a ~^ b;
endmodule