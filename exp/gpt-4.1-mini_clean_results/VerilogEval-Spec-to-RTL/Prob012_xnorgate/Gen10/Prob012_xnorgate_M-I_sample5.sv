module TopModule (
    input  a,
    input  b,
    output out
);
    assign out = ~(a ^ b); // Direct single-bit XNOR operation
endmodule