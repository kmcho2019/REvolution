module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR implementation using XOR and negation
    assign out = ~(a ^ b);
endmodule