module TopModule (
    input a,
    input b,
    output out
);
    // XNOR: out = ~(a ^ b) = (a == b)
    assign out = a ~^ b;  // Direct XNOR implementation
endmodule