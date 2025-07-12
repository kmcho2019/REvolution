module mux2to1 (
    input  in0,
    input  in1,
    input  sel,
    output out
);
    // Simple 2-to-1 multiplexer
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] = (c) ? 1 : d
    // Build d (identity) using mux2to1: mux2to1(0,1,d) = d
    wire d_id;
    mux2to1 mux0_0 (.in0(1'b0), .in1(1'b1), .sel(d), .out(d_id));
    // Then mux_in[0] = mux2to1(d_id,1,c)
    mux2to1 mux0_1 (.in0(d_id), .in1(1'b1), .sel(c), .out(mux_in[0]));

    // mux_in[1] = 0 (all zeros)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = (c) ? d : 0
    mux2to1 mux2_0 (.in0(1'b0), .in1(d), .sel(c), .out(mux_in[2]));

    // mux_in[3] = (c) ? 1 : ~d
    // Implement ~d as mux2to1(1,0,d)
    wire not_d;
    mux2to1 mux_notd (.in0(1'b1), .in1(1'b0), .sel(d), .out(not_d));
    mux2to1 mux3_0 (.in0(not_d), .in1(1'b1), .sel(c), .out(mux_in[3]));

endmodule