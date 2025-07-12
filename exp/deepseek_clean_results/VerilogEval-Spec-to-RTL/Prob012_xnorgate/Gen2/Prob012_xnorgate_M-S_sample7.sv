module TopModule (
    input a,
    input b,
    output out
);
    assign out = (a == b);  // Direct equality check implements XNOR
endmodule