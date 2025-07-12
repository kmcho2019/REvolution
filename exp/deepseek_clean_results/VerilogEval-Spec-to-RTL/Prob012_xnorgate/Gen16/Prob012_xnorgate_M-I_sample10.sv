module TopModule (
    input a,
    input b,
    output out
);
    // Direct XNOR implementation using primitive operator
    assign out = ~(a ^ b);
endmodule