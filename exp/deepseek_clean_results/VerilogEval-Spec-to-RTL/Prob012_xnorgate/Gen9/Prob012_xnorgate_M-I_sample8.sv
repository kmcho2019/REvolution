module TopModule (
    input a,
    input b,
    output out
);
    assign out = (a == b);  // XNOR using equality operator
endmodule