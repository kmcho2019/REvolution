module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire condition1, condition2, condition3, condition4;

// Condition 1: (!a && !c)
assign condition1 = ~a & ~c;

// Condition 2: (b && d)
assign condition2 = b & d;

// Condition 3: (b && !c)
assign condition3 = b & ~c;

// Condition 4: (!a && b)
assign condition4 = ~a & b;

// Combine conditions to produce final output
assign out = condition1 | condition2 | condition3 | condition4;

endmodule