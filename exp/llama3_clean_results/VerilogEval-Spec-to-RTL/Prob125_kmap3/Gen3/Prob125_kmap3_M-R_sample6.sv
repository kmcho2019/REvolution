module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Though 'd' is a don't-care, it's included for completeness
    output out
);

assign out = (b == 1) || (b == 0 && a == 1 && c == 0);

endmodule