module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b;  // Explicit XNOR operator, functionally identical to a == b
endmodule