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
    // mux_in[0] = d ? 1 : c
    wire m0;
    mux2 mux0 (.sel(d), .in0(c), .in1(1'b1), .out(m0));

    // mux_in[1] = 0
    wire m1 = 1'b0;

    // mux_in[2] = c ? d : 0
    wire m2;
    mux2 mux2_inst (.sel(c), .in0(1'b0), .in1(d), .out(m2));

    // mux_in[3] = d ? 1 : c
    wire m3;
    mux2 mux3 (.sel(d), .in0(c), .in1(1'b1), .out(m3));

    assign mux_in = {m3, m2, m1, m0};
endmodule