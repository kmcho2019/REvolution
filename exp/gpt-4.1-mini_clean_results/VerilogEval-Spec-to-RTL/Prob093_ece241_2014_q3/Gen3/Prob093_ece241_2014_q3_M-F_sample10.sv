// 2-to-1 multiplexer module definition
module mux2to1 (
    input  wire sel,
    input  wire in0,
    input  wire in1,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);

    // Generate ~d = mux(d,1,0)
    wire not_d;
    mux2to1 u_not_d (
        .sel(d),
        .in0(1'b1),
        .in1(1'b0),
        .out(not_d)
    );

    // Generate ~c = mux(c,1,0)
    wire not_c;
    mux2to1 u_not_c (
        .sel(c),
        .in0(1'b1),
        .in1(1'b0),
        .out(not_c)
    );

    // mux_in[0] = c & ~d = mux(sel=c, in0=0, in1=not_d)
    wire mux0;
    mux2to1 u_mux0 (
        .sel(c),
        .in0(1'b0),
        .in1(not_d),
        .out(mux0)
    );

    // mux_in[1] = ~c & ~d = mux(sel=not_c, in0=0, in1=not_d)
    wire mux1;
    mux2to1 u_mux1 (
        .sel(not_c),
        .in0(1'b0),
        .in1(not_d),
        .out(mux1)
    );

    // mux_in[2] = c + ~d = mux(sel=c, in0=not_d, in1=1)
    wire mux2;
    mux2to1 u_mux2 (
        .sel(c),
        .in0(not_d),
        .in1(1'b1),
        .out(mux2)
    );

    // mux_in[3] = ~d = not_d
    wire mux3 = not_d;

    assign mux_in = {mux3, mux2, mux1, mux0};

endmodule