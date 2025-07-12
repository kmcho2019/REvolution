module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// The current expression already seems optimized, but let's try to simplify it further if possible.
assign out = a || (!a && !b && c);

// Alternative approach, focusing on directly implementing the Karnaugh map logic:
// assign out = (a) || (!a && !b && c);

endmodule