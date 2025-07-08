module mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    wire temp0_0, temp0_1; // For mux_in[0]
    wire temp3_0;          // For mux_in[3]

    // mux_in[0] = c OR d
    // Implement c OR d using two 2-to-1 muxes
    // Step 1: mux with d as select, inputs 0 and 1 -> output = d ? 1 : 0 = d
    // Step 2: mux with c as select, inputs temp0_0 and 1 -> output = c ? 1 : d = c + d
    mux2to1 mux0_0 (
        .sel(d),
        .in0(1'b0),
        .in1(1'b1),
        .out(temp0_0)
    );
    mux2to1 mux0_1 (
        .sel(c),
        .in0(temp0_0),
        .in1(1'b1),
        .out(mux_in[0])
    );

    // mux_in[1] = 0 (all zero)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c AND d
    // Implement c AND d using 2-to-1 muxes:
    // c AND d = mux with c as select, inputs 0 and d
    mux2to1 mux2_0 (
        .sel(c),
        .in0(1'b0),
        .in1(d),
        .out(mux_in[2])
    );

    // mux_in[3] = (~c & ~d) | c = c OR (~c AND ~d)
    // Implement as mux with c as select, inputs ~d and 1
    assign temp3_0 = ~d;
    mux2to1 mux3_0 (
        .sel(c),
        .in0(temp3_0),
        .in1(1'b1),
        .out(mux_in[3])
    );
endmodule