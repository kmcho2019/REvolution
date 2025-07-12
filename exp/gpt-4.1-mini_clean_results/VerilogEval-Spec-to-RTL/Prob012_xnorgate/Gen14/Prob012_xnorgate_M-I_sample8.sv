module TopModule(
    input  a,
    input  b,
    output out
);
    // Direct XNOR implementation using built-in operator for minimal area and delay
    assign out = a ~^ b;
endmodule