module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Direct and simple implementation focusing on minimizing logic complexity
// Using bitwise OR operator for efficiency
assign out = a | (!a & ~b & c);

endmodule