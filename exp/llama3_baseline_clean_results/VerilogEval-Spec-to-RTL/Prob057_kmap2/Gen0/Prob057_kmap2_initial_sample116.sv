module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Directly implement the logic from the Karnaugh map
assign out = (a && b && c && d) ||
             (!a && b && c && d) ||
             (a && !b && c && d) ||
             (a && b && !c && d) ||
             (a && b && c && !d) ||
             (!a && !b && !c && !d) ||
             (!a && !b && !c && d) ||
             (!a && !b && c && !d) ||
             (!a && b && !c && !d) ||
             (a && !b && !c && !d);

endmodule