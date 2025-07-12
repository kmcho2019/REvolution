module TopModule (
    input  a,
    input  b,
    output out
);
    // XNOR operation: out = 1 when inputs are equal
    assign out = ~(a ^ b);
endmodule