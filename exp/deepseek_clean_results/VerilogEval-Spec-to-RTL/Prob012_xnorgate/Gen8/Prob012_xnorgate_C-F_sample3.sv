module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b;  // Direct and optimal XNOR implementation
endmodule