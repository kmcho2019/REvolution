module TopModule (
    input a,
    input b,
    output out
);
    // Explicit XNOR implementation using ~^ operator
    assign out = a ~^ b;
endmodule