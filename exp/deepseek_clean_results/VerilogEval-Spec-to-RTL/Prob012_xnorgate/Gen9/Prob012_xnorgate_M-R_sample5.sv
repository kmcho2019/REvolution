module TopModule (
    input a,
    input b,
    output out
);
    // Direct implementation using XNOR operator
    assign out = ~(a ^ b);
endmodule