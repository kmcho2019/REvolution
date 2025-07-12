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
    // Implement ~d using mux2
    wire not_d;
    mux2 inv_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // mux_in[0] = c ? 1 : d
    wire f0;
    mux2 f0_mux(.sel(c), .in0(d), .in1(1'b1), .out(f0));

    // mux_in[1] = 0
    wire f1 = 1'b0;

    // mux_in[2] = c ? d : 0
    wire f2;
    mux2 f2_mux(.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // mux_in[3] = c ? 1 : ~d
    wire f3;
    mux2 f3_mux(.sel(c), .in0(not_d), .in1(1'b1), .out(f3));

    assign mux_in = {f3, f2, f1, f0};
endmodule