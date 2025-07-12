module TopModule (
    input c,
    input d,
    output [3:0] mux_in
);

    wire not_d;
    wire or_cd;
    wire and_cd;
    wire or_c_notd;

    // mux_in[0]: c OR d
    assign or_cd = c ? 1'b1 : d;

    // mux_in[1]: constant 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]: c AND d
    assign and_cd = c ? d : 1'b0;

    // mux_in[3]: NOT d OR c
    assign not_d = d ? 1'b0 : 1'b1;
    assign or_c_notd = c ? 1'b1 : not_d;

    assign mux_in[0] = or_cd;
    assign mux_in[2] = and_cd;
    assign mux_in[3] = or_c_notd;

endmodule