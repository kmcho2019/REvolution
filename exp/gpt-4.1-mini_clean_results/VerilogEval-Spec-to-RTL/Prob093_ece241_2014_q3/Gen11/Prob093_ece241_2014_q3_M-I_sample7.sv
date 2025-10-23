module mux2to1 (
    input  in0,
    input  in1,
    input  sel,
    output out
);
    // 2-to-1 multiplexer implementation
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Implement mux_in[0] for ab=00 column: cd=00->0, 01->1, 11->1, 10->1
    // Inputs: c,d
    // Use c as selector between two muxes on d:
    // For c=0 (cd=00 or 01): output 0 or 1 => mux2to1(d=0->0, d=1->1) = d
    // For c=1 (cd=10 or 11): both 1
    // So first mux: mux2to1(d=0, d=1, c) -> out = c ? 1 : d
    // Implement: mux_in[0] = c ? 1 : d;
    // To use only mux2to1, build as:
    // tmp0 = mux2to1(d=0, d=1, d) = d (identity)
    // mux_in[0] = mux2to1(tmp0= d, 1, c) = c ? 1 : d

    wire tmp0_0;
    mux2to1 mux0_0 (.in0(1'b0), .in1(1'b1), .sel(d), .out(tmp0_0)); // tmp0_0 = d
    mux2to1 mux0_1 (.in0(tmp0_0), .in1(1'b1), .sel(c), .out(mux_in[0]));

    // Implement mux_in[1] for ab=01 column: all zeros
    assign mux_in[1] = 1'b0;

    // Implement mux_in[2] for ab=11 column: cd=00->0, 01->0, 11->1, 10->0
    // For c=0 (cd=00,01): output 0
    // For c=1 (cd=10,11): output depends on d (10->0,11->1)
    // So mux_in[2] = c ? d : 0
    wire zero = 1'b0;
    mux2to1 mux2_0 (.in0(zero), .in1(d), .sel(c), .out(mux_in[2]));

    // Implement mux_in[3] for ab=10 column: cd=00->1, 01->0, 11->1, 10->1
    // Analyze d for c=0:
    // c=0: d=0 ->1, d=1 ->0  (output = ~d)
    // c=1: always 1
    // No inversion allowed, so implement ~d with muxes:
    // ~d can be implemented as mux2to1(d=1, d=0, d)
    // Use d as selector between 1 and 0 -> out = ~d

    wire not_d;
    mux2to1 mux_notd (.in0(1'b1), .in1(1'b0), .sel(d), .out(not_d));

    // Now mux_in[3] = c ? 1 : ~d
    mux2to1 mux3_0 (.in0(not_d), .in1(1'b1), .sel(c), .out(mux_in[3]));

endmodule