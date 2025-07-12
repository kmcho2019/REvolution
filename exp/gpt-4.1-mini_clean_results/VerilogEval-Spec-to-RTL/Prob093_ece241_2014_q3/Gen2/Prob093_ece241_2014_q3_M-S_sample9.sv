// 2-to-1 multiplexer module defined separately as required
module mux2to1 (
    input wire sel,
    input wire in0,
    input wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);
    // NOT d implemented using mux2to1: not_d = d ? 0 : 1
    wire not_d;
    mux2to1 u_not_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // mux_in[0]: For ab=00:
    // From K-map: out=1 when (c,d) != (0,0), else 0
    // Expression: if c=0 then out=d else 1
    wire mux0_d;
    mux2to1 u_mux0_d (.sel(d), .in0(1'b0), .in1(1'b1), .out(mux0_d)); // d mux: 0->0, 1->1
    mux2to1 u_mux0_c (.sel(c), .in0(mux0_d), .in1(1'b1), .out(mux_in[0]));

    // mux_in[1]: For ab=01:
    // K-map all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2]: For ab=11:
    // c & d using muxes:
    // if d=0 out=0 else out=c
    mux2to1 u_mux2_d (.sel(d), .in0(1'b0), .in1(c), .out(mux_in[2]));

    // mux_in[3]: For ab=10:
    // out = c + (~c & ~d) = c OR (not c AND not d)
    // Implemented using muxes:
    // d_mux = d ? 0 : 1
    wire d_mux;
    mux2to1 u_d_mux (.sel(d), .in0(1'b1), .in1(1'b0), .out(d_mux));
    // out = c ? 1 : d_mux
    mux2to1 u_mux3_c (.sel(c), .in0(d_mux), .in1(1'b1), .out(mux_in[3]));

endmodule