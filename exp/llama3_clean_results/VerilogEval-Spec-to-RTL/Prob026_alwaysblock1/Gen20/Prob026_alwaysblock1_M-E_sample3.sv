// Module for AND gate implementation using assign statement
module AndGateAssign(
    input  a,
    input  b,
    output out
);
    
assign out = a & b;

endmodule

// Module for AND gate implementation using combinational always block
module AndGateAlways(
    input  a,
    input  b,
    output out
);
    
reg out_reg;
always @(*) begin
    out_reg = a & b;
end
assign out = out_reg;

endmodule

// TopModule that instantiates the AND gate modules
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

AndGateAssign u_and_assign(
    .a(a),
    .b(b),
    .out(out_assign)
);

AndGateAlways u_and_always(
    .a(a),
    .b(b),
    .out(out_alwaysblock)
);

endmodule