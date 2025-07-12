module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b;  // Direct XNOR operation - most explicit and optimal
endmodule