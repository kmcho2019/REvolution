module AndGateAssign(
    input  a,
    input  b,
    output out_assign
);

assign out_assign = a & b;

endmodule

module AndGateAlways(
    input  a,
    input  b,
    output out_alwaysblock
);

assign out_alwaysblock = a & b;

endmodule

module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

AndGateAssign u_and_gate_assign(
   .a(a),
   .b(b),
   .out_assign(out_assign)
);

AndGateAlways u_and_gate_always(
   .a(a),
   .b(b),
   .out_alwaysblock(out_alwaysblock)
);

endmodule