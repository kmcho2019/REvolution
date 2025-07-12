module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First level: groups of 10 inputs
    wire [9:0] and_level1;
    wire [9:0] or_level1;
    wire [9:0] xor_level1;

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin
            and_or_xor and_or_xor_inst(
                .in(in[(i*10)+9:i*10]),
                .and_out(and_level1[i]),
                .or_out(or_level1[i]),
                .xor_out(xor_level1[i])
            );
        end
    endgenerate

    // Second level: combine results of 10 groups
    wire [9:0] and_level2;
    wire [9:0] or_level2;
    wire [9:0] xor_level2;

    generate
        for (i = 0; i < 10; i = i + 1) begin
            and_or_xor and_or_xor_inst2(
                .in({and_level1[9:0], or_level1[9:0], xor_level1[9:0]}),
                .and_out(and_level2[i]),
                .or_out(or_level2[i]),
                .xor_out(xor_level2[i])
            );
        end
    endgenerate

    // Third level: combine results of 10 groups from second level
    wire [9:0] and_level3;
    wire [9:0] or_level3;
    wire [9:0] xor_level3;

    generate
        for (i = 0; i < 10; i = i + 1) begin
            and_or_xor and_or_xor_inst3(
                .in({and_level2[9:0], or_level2[9:0], xor_level2[9:0]}),
                .and_out(and_level3[i]),
                .or_out(or_level3[i]),
                .xor_out(xor_level3[i])
            );
        end
    endgenerate

    // Fourth level: combine results of 10 groups from third level
    wire and_out;
    wire or_out;
    wire xor_out;

    and_or_xor and_or_xor_inst4(
        .in({and_level3[9:0], or_level3[9:0], xor_level3[9:0]}),
        .and_out(and_out),
        .or_out(or_out),
        .xor_out(xor_out)
    );

    assign out_and = and_out;
    assign out_or = or_out;
    assign out_xor = xor_out;

endmodule

module and_or_xor(
    input [9:0] in,
    output and_out,
    output or_out,
    output xor_out
);

    assign and_out = &in;
    assign or_out = |in;
    assign xor_out = ^in;

endmodule