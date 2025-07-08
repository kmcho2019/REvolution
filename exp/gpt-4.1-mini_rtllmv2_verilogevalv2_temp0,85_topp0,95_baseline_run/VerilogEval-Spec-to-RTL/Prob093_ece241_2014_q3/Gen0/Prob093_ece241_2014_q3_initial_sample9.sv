module mux2 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);
    wire d_not;
    wire mux0_c1, mux1_c1, mux2_c1, mux3_c1;
    wire mux_in0, mux_in1, mux_in2, mux_in3;

    // d_not = ~d implemented as mux2 with sel=d, inputs 1 and 0
    mux2 d_inv (
        .sel(d),
        .d0(1'b1),
        .d1(1'b0),
        .y(d_not)
    );

    // mux_in[0]: cd-> 00:0,01:0,11:0,10:1
    // For c=0: f0 = d=0:0, d=1:0 -> f0=0
    // For c=1: f1 = d=0:1, d=1:0 -> f1 = d'
    // Implement mux_in[0] = c ? d_not : 0
    mux2 mux_in0_mux (
        .sel(c),
        .d0(1'b0),
        .d1(d_not),
        .y(mux_in[0])
    );

    // mux_in[1]: cd-> 00:1,01:0,11:0,10:0
    // For c=0: d=0:1, d=1:0 -> f0 = d_not
    // For c=1: d=0:0, d=1:0 -> f1 = 0
    // mux_in[1] = c ? 0 : d_not
    mux2 mux_in1_mux (
        .sel(c),
        .d0(d_not),
        .d1(1'b0),
        .y(mux_in[1])
    );

    // mux_in[2]: cd-> 00:1,01:0,11:0,10:1
    // For c=0: d=0:1, d=1:0 -> f0 = d_not
    // For c=1: d=0:1, d=1:0 -> f1 = d_not
    // mux_in[2] = c ? d_not : d_not = d_not
    assign mux_in[2] = d_not;

    // mux_in[3]: cd-> 00:1,01:0,11:1,10:1
    // For c=0: d=0:1, d=1:0 -> f0 = d_not
    // For c=1: d=0:1, d=1:1 -> f1 = 1 (since for d=0 and d=1 both output 1)
    // mux_in[3] = c ? 1 : d_not
    mux2 mux_in3_mux (
        .sel(c),
        .d0(d_not),
        .d1(1'b1),
        .y(mux_in[3])
    );

endmodule