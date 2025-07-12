module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // Though d is a don't-care, it's included as per the problem statement
    output out
);

assign out = (c && b) || (!c && b);

endmodule