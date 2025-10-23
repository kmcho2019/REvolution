// Module for assign statement implementation
module AndAssign(
    input  a,
    input  b,
    output out_assign
);

assign out_assign = a & b;

endmodule

// Module for combinational always block implementation
module AndAlways(
    input  a,
    input  b,
    output reg out_alwaysblock
);

always @(*) begin
    out_alwaysblock = a & b;
end

endmodule

// TopModule instantiates both implementations
module TopModule(
    input  a,
    input  b,
    output out_assign,
    output out_alwaysblock
);

AndAssign u_and_assign(
    .a(a),
    .b(b),
    .out_assign(out_assign)
);

AndAlways u_and_always(
    .a(a),
    .b(b),
    .out_alwaysblock(out_alwaysblock)
);

endmodule