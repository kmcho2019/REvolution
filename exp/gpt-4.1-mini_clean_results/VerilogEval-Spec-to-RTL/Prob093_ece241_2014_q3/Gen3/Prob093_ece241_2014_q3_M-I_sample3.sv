module mux2(
    input i0,
    input i1,
    input sel,
    output y
);
    assign y = sel ? i1 : i0;
endmodule

module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);
    wire not_d;
    wire c_or_d;
    wire c_and_d;
    wire c_or_notd;

    // NOT d = mux(1,0,d)
    mux2 u_not_d(
        .i0(1'b1), 
        .i1(1'b0), 
        .sel(d), 
        .y(not_d)
    );

    // c OR d = mux(d,1,c)
    mux2 u_c_or_d(
        .i0(d), 
        .i1(1'b1), 
        .sel(c), 
        .y(c_or_d)
    );

    // c AND d = mux(0,d,c)
    mux2 u_c_and_d(
        .i0(1'b0), 
        .i1(d), 
        .sel(c), 
        .y(c_and_d)
    );

    // c OR not_d = mux(not_d,1,c)
    mux2 u_c_or_notd(
        .i0(not_d), 
        .i1(1'b1), 
        .sel(c), 
        .y(c_or_notd)
    );

    // Assign mux_in according to ab selector inputs:
    // ab=00 -> mux_in[0] = c OR d
    assign mux_in[0] = c_or_d;

    // ab=01 -> mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // ab=11 -> mux_in[2] = c AND d
    assign mux_in[2] = c_and_d;

    // ab=10 -> mux_in[3] = c OR ~d
    assign mux_in[3] = c_or_notd;

endmodule