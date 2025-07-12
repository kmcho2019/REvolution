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
    input  select, // Control signal for the multiplexer
    output out
);

wire and_assign;
wire and_alwaysblock;

AndGate u_and_gate(
   .a(a),
   .b(b),
   .out_assign(and_assign),
   .out_alwaysblock(and_alwaysblock)
);

assign out = select ? and_alwaysblock : and_assign;

endmodule