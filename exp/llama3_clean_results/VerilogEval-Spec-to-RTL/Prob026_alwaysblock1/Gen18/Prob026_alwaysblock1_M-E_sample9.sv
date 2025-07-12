module GenericGate(
    input  a,
    input  b,
    input  [1:0] gate_type,
    output out_assign,
    output out_alwaysblock
);

assign out_assign = (gate_type == 2'b00)? (a & b) : 
                    (gate_type == 2'b01)? (a | b) : 
                    (gate_type == 2'b10)? (a ^ b) : 
                    1'b0;

reg out_alwaysblock_reg;
always @(*) begin
    case (gate_type)
        2'b00: out_alwaysblock_reg = a & b;
        2'b01: out_alwaysblock_reg = a | b;
        2'b10: out_alwaysblock_reg = a ^ b;
        default: out_alwaysblock_reg = 1'b0;
    endcase
end
assign out_alwaysblock = out_alwaysblock_reg;

endmodule

module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

GenericGate u_generic_gate(
   .a(a),
   .b(b),
   .gate_type(2'b00),
   .out_assign(out_assign),
   .out_alwaysblock(out_alwaysblock)
);

endmodule