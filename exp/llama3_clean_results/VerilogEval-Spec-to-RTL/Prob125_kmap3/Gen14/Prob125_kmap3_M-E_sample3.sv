module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Though 'd' is don't-care, it's included for completeness
    output out
);

assign out = (a) || (!b && c);

endmodule