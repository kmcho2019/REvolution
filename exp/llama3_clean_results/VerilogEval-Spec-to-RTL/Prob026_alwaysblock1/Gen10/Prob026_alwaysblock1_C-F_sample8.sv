module AndGate(
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

assign out_assign = a & b;

always @(*) begin
    out_alwaysblock = a & b;
end

endmodule

module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

AndGate u_and_gate(
   .a(a),
   .b(b),
   .out_assign(out_assign),
   .out_alwaysblock(out_alwaysblock)
);

endmodule