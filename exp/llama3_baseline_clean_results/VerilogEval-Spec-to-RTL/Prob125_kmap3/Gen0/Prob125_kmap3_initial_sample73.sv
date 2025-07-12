module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // This input is not used due to don't-care condition
    output out
);
    assign out = (~a & ~c) | (a & c) | (b & c);
endmodule