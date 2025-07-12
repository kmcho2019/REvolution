module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // 'd' is don't-care, not used in the logic
    output out
);

// Simplified and efficient implementation of the logic
assign out = a || (!a && !b && c);

endmodule