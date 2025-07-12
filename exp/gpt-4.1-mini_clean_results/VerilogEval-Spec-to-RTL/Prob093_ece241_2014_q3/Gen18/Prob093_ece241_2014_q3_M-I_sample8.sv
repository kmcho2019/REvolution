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
    // Implement ~d using mux2: not_d = mux2(sel=d, in0=1, in1=0)
    wire not_d;
    mux2 inv_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // f0 for ab=00: f0 = mux2(sel=c, in0=d, in1=1)
    wire f0;
    mux2 f0_mux(.sel(c), .in0(d), .in1(1'b1), .out(f0));

    // f1 for ab=01: constant 0
    wire f1 = 1'b0;

    // f2 for ab=11: f2 = mux2(sel=c, in0=0, in1=d)
    wire f2;
    mux2 f2_mux(.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // f3 for ab=10: f3 = mux2(sel=c, in0=not_d, in1=1)
    wire f3;
    mux2 f3_mux(.sel(c), .in0(not_d), .in1(1'b1), .out(f3));

    // Assign mux_in according to ab selector mapping of the 4-to-1 mux:
    // mux_in[0] = f0 (ab=00)
    // mux_in[1] = f1 (ab=01)
    // mux_in[2] = f2 (ab=11)
    // mux_in[3] = f3 (ab=10)
    assign mux_in = {f3, f2, f1, f0};

endmodule