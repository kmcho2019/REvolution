module TopModule (
    input a,
    input b,
    output out
);
    // Implement XNOR using a multiplexer
    // When a is 1, select b
    // When a is 0, select ~b
    assign out = a ? b : ~b;
endmodule