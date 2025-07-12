module TopModule (
    input a,
    input b,
    output out
);
    // MUX implementation of XNOR
    assign out = a ? b : ~b;
endmodule