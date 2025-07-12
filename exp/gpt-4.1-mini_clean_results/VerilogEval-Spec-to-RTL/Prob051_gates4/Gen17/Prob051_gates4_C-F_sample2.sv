module FourInputLogicTree (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Balanced 2-input AND tree
    wire and_level1_0, and_level1_1;
    and u_and0(and_level1_0, in[0], in[1]);
    and u_and1(and_level1_1, in[2], in[3]);
    and u_and2(out_and,     and_level1_0, and_level1_1);

    // Balanced 2-input OR tree
    wire or_level1_0, or_level1_1;
    or u_or0(or_level1_0, in[0], in[1]);
    or u_or1(or_level1_1, in[2], in[3]);
    or u_or2(out_or,     or_level1_0, or_level1_1);

    // XOR reduction operator for 4-input XOR
    assign out_xor = ^in;
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Instantiate the single unified logic module
    FourInputLogicTree u_logic (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );
endmodule