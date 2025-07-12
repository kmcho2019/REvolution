module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct continuous assignment implementing XNOR without extra modules or wires
    assign out = ~(a ^ b);
endmodule