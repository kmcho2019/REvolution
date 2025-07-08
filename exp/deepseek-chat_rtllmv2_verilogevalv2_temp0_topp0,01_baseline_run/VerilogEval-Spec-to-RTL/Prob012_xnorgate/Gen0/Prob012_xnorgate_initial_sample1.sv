module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a ^ b);  // XNOR operation: equivalent to (a & b) | (~a & ~b)
endmodule