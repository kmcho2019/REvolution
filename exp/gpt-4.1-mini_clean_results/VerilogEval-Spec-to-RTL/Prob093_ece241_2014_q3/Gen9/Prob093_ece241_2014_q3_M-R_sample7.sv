module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] (ab=00): f0 = d ? 1 : c
    wire f0;
    mux2 mux0 (.sel(d), .in0(c), .in1(1'b1), .out(f0));

    // mux_in[1] (ab=01): f1 = 0
    wire f1 = 1'b0;

    // mux_in[2] (ab=11): f3 = c & d = mux2(sel=c, in0=0, in1=d)
    wire f3;
    mux2 mux2_inst (.sel(c), .in0(1'b0), .in1(d), .out(f3));

    // mux_in[3] (ab=10): f2 = c + ~d
    // ~d = mux2(sel=d, in0=1, in1=0)
    wire not_d;
    mux2 mux_not_d (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));
    // f2 = mux2(sel=d, in0=c, in1=1) since c + ~d = (d=0->c, d=1->1)
    wire f2;
    mux2 mux3 (.sel(d), .in0(c), .in1(1'b1), .out(f2));

    // Assign outputs as per ab mapping to mux_in:
    // mux_in[3] = f2 (ab=10)
    // mux_in[2] = f3 (ab=11)
    // mux_in[1] = f1 (ab=01)
    // mux_in[0] = f0 (ab=00)
    assign mux_in = {f2, f3, f1, f0};
endmodule