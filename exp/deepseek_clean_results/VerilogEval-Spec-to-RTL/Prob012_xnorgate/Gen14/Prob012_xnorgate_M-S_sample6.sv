// Simplified XNOR gate implementation
module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR operation
    assign out = a ~^ b;
endmodule