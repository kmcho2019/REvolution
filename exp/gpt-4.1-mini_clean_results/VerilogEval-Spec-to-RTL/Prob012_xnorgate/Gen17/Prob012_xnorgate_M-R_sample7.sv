module TopModule(
    input  a,
    input  b,
    output out
);
    assign out = a ~^ b;  // direct XNOR using built-in operator
endmodule