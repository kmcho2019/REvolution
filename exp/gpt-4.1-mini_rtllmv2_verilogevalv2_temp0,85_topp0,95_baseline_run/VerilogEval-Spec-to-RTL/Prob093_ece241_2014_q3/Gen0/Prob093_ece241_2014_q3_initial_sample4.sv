module TwoToOneMux (
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

    wire not_d;
    wire c_and_d;
    wire or_c_d;
    wire or_notd_and;

    // not_d = ~d
    TwoToOneMux not_d_mux (
        .sel(d),
        .d0(1'b1),
        .d1(1'b0),
        .y(not_d)
    );

    // c_and_d = c & d
    TwoToOneMux and_c_d_mux (
        .sel(c),
        .d0(1'b0),
        .d1(d),
        .y(c_and_d)
    );

    // or_c_d = c + d
    TwoToOneMux or_c_d_mux (
        .sel(c),
        .d0(d),
        .d1(1'b1),
        .y(or_c_d)
    );

    // or_notd_and = not_d + c_and_d
    TwoToOneMux or_notd_and_mux (
        .sel(not_d),
        .d0(c_and_d),
        .d1(1'b1),
        .y(or_notd_and)
    );

    assign mux_in[0] = or_c_d;       // ab=00
    assign mux_in[1] = 1'b0;         // ab=01
    assign mux_in[2] = c_and_d;      // ab=11
    assign mux_in[3] = or_notd_and;  // ab=10

endmodule