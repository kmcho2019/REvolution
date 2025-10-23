module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output wire q
);

assign q = a ~^ b ~^ c ~^ d;

endmodule