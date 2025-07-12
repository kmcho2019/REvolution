module TopModule (
    input  a,
    input  b,
    output out
);
    // Direct combinational assign implementing XNOR
    assign out = ~(a ^ b);
endmodule