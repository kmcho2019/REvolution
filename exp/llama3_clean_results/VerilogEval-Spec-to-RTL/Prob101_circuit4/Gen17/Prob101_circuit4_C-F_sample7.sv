module OR_Gate(
    input  a,
    input  b,
    output q
);
    
assign q = a | b;

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Direct OR operation implementation
// This is potentially more area-efficient than instantiating a separate module for a simple operation.
assign q = b | c;

// Alternatively, if modularity is preferred for readability or reusability:
// OR_Gate or_gate(
//    .a(b),
//    .b(c),
//    .q(q)
// );

endmodule