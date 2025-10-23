module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR implementation using logical operators
    assign out = ~(a ^ b);
endmodule