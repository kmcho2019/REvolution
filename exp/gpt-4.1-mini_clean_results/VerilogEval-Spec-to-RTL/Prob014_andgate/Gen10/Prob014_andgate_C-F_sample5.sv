module TopModule (
    input  a,
    input  b,
    output out
);

// Continuous assignment implements a 2-input AND gate
assign out = a & b;

endmodule