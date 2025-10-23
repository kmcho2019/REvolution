// 2-to-1 multiplexer module definition
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
    // Build NOT d using 2-to-1 mux:
    // ~d = mux2to1 with sel=d, in0=1, in1=0
    wire not_d;
    mux2to1 u_not_d (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(not_d)
    );

    // mux_in[0]: out = c ? 1 : d
    // Use two 2-to-1 muxes:
    // First mux: sel=d, in0=0, in1=1 => out = d
    wire d_as_mux0;
    mux2to1 u_mux0_d (
        .sel(d),
        .in0(1'b0),
        .in1(1'b1),
        .out(d_as_mux0)
    );
    // Second mux: sel=c, in0=d_as_mux0, in1=1
    wire mux0;
    mux2to1 u_mux0_c (
        .sel(c),
        .in0(d_as_mux0),
        .in1(1'b1),
        .out(mux0)
    );

    // mux_in[1]: all zeros
    wire mux1 = 1'b0;

    // mux_in[2]: out = c & d
    // Implement with one mux:
    // sel = d, in0 = 0, in1 = c
    wire mux2;
    mux2to1 u_mux2_d (
        .sel(d),
        .in0(1'b0),
        .in1(c),
        .out(mux2)
    );

    // mux_in[3]: out = c ? 1 : ~d
    // Use not_d already defined
    // mux: sel=c, in0=not_d, in1=1
    wire mux3;
    mux2to1 u_mux3_c (
        .sel(c),
        .in0(not_d),
        .in1(1'b1),
        .out(mux3)
    );

    // Assign all outputs as vector
    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule