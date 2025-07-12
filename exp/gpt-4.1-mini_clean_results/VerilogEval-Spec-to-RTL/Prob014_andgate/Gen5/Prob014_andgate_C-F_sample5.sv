module TopModule (
    input  wire a,
    input  wire b,
    output wire out
);

// Continuous assignment for a 2-input AND gate
assign out = a & b;

endmodule