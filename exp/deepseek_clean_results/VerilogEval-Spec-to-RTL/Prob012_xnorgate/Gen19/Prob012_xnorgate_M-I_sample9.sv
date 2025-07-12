module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR gate implementation
    assign out = a ~^ b;
endmodule