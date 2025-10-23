module TopModule (
    input a,
    input b,
    output out
);
    // Direct implementation of XNOR using equality operator
    assign out = (a ~^ b);
endmodule