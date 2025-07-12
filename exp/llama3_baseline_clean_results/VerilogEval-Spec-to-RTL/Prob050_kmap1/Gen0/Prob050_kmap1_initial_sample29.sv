module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

assign out = a || (b && c) || (b && !c) || (!b && c);
// Alternatively, if simplification missed the bc=11 case specifically:
// assign out = a || (b || c);

endmodule