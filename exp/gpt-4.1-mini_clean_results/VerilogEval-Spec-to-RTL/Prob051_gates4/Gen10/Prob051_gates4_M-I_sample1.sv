module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    wire and_wire = &in;
    wire or_wire  = |in;
    wire xor_wire = ^in;

    assign out_and = and_wire;
    assign out_or  = or_wire;
    assign out_xor = xor_wire;

endmodule