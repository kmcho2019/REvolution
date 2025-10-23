module mux2to1 (
    input  wire sel,
    input  wire in0,
    input  wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);

    // mux_in[0] (ab=00): out = c + d = d ? 1 : c
    wire mux0;
    mux2to1 mux0_inst (.sel(d), .in0(c), .in1(1'b1), .out(mux0));

    // mux_in[1] (ab=01): always 0
    wire mux1 = 1'b0;

    // mux_in[2] (ab=11): out = c & d = d ? c : 0
    wire mux2;
    mux2to1 mux2_inst (.sel(d), .in0(1'b0), .in1(c), .out(mux2));

    // mux_in[3] (ab=10): out = (~d) + c
    // ~d = d ? 0 : 1
    wire not_d;
    mux2to1 notd_inst (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));
    // out = c ? 1 : not_d
    wire mux3;
    mux2to1 mux3_inst (.sel(c), .in0(not_d), .in1(1'b1), .out(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule