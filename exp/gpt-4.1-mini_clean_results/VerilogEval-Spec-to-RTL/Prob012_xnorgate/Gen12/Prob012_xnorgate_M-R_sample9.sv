module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct XNOR implementation using continuous assignment with built-in operator
    assign out = ~(a ^ b);
endmodule