module AndGate(
    input  a,
    input  b,
    output out_assign
);

assign out_assign = a & b;

endmodule

module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

AndGate u_and_gate_assign(
   .a(a),
   .b(b),
   .out_assign(out_assign)
);

always @(*)
    out_alwaysblock = a & b;

endmodule