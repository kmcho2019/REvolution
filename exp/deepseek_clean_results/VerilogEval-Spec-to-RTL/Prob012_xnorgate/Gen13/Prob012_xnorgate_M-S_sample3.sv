module TopModule (
    input a,
    input b,
    output out
);
    // Simplest possible XNOR implementation using equality operator
    assign out = (a == b);
endmodule