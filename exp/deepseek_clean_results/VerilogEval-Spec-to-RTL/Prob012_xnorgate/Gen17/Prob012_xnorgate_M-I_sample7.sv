module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR implementation
    assign out = ~(a ^ b);
endmodule