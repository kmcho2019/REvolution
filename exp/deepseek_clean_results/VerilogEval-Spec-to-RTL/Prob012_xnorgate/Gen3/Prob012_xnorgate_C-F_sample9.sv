module TopModule (
    input a,
    input b,
    output out
);
    assign out = a ~^ b;  // Direct XNOR operator for clearest intent
endmodule