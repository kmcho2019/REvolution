module TopModule (
    input a,
    input b,
    output out
);
    // Direct gate-level implementation of XNOR
    assign out = ~(a ^ b);
endmodule