module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Direct and simple implementation focusing on minimizing logic complexity
assign out = a | (!a & !b & c);

// Alternatively, if the synthesis tool and target technology benefit from it,
// using the conditional operator for explicitness, though likely not necessary here
// assign out = a ? 1'b1 : (!b & c);

endmodule