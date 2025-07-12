module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Final simplification considering the properties of Boolean algebra
assign out = (a | b) & (~c | d);

endmodule