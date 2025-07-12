module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

// Direct assignments to match the wire-like behavior
assign w = a;
assign x = b;
assign y = b;
assign z = c;

endmodule