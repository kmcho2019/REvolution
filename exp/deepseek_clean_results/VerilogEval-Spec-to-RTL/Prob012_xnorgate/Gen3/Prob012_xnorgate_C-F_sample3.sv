module TopModule (
    input a,
    input b,
    output out
);
    // XNOR: out = ~(a ^ b) = (a == b) = a ~^ b
    assign out = a ~^ b;  // Most efficient XNOR implementation
endmodule