module TwoToOneMux (
    input wire sel,
    input wire d0,
    input wire d1,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);
    wire not_c;
    wire or_c_d_0; // c+d for mux_in[0]
    wire and_c_d;  // c*d for mux_in[3]
    wire or_notc_d; // ~c + d for mux_in[2]

    // Implement NOT c = mux(sel=c, d0=1, d1=0)
    // mux: y = sel ? d1 : d0
    // For NOT: if c=0 => y=1; if c=1 => y=0
    TwoToOneMux notc_mux (
        .sel(c),
        .d0(1'b1),
        .d1(1'b0),
        .y(not_c)
    );

    // OR c + d = mux(sel=d, d0=c, d1=1)
    // when d=0 => y=c; d=1 => y=1
    TwoToOneMux or_c_d_mux (
        .sel(d),
        .d0(c),
        .d1(1'b1),
        .y(or_c_d_0)
    );

    // AND c & d = mux(sel=c, d0=0, d1=d)
    // when c=0 => y=0; c=1 => y=d
    TwoToOneMux and_c_d_mux (
        .sel(c),
        .d0(1'b0),
        .d1(d),
        .y(and_c_d)
    );

    // OR ~c + d:
    // ~c = not_c
    // Use OR as mux(sel=d, d0=not_c, d1=1)
    TwoToOneMux or_notc_d_mux (
        .sel(d),
        .d0(not_c),
        .d1(1'b1),
        .y(or_notc_d)
    );

    assign mux_in[0] = or_c_d_0; // c + d
    assign mux_in[1] = 1'b0;     // constant 0
    assign mux_in[2] = or_notc_d; // ~c + d
    assign mux_in[3] = and_c_d;  // c & d

endmodule