module TopModule (
    input  a,
    input  b,
    output wire out
);
    nor (out, a, b);
endmodule