module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);
    // Direct single-level XNOR gate implementation with minimal hierarchy
    assign out = ~(a ^ b);
endmodule