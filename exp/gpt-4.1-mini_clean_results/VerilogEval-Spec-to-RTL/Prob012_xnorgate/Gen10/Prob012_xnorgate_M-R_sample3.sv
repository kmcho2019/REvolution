module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct continuous assignment implementing XNOR operation
    assign out = ~(a ^ b);
endmodule