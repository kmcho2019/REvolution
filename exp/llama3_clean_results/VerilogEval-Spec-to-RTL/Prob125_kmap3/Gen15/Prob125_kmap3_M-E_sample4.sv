module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire ab_or_c; // Intermediate signal for (a || b || c)

assign ab_or_c = a || b || c;

assign out = ab_or_c || (!a && !b && c);

endmodule