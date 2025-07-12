module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

// From the Karnaugh map, output is 0 only when a=0, b=0, c=0;
// otherwise output is 1.
// Therefore, out = a OR b OR c.
assign out = a | b | c;

endmodule