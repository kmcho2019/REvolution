module mux2(input sel, input d0, input d1, output y);
    assign y = sel ? d1 : d0;
endmodule

module TopModule(input c, input d, output [3:0] mux_in);
    // Implement ~d using a 2-to-1 mux with select = d,
    // inputs = 1 and 0 to invert d
    wire not_d;
    mux2 inv_not_d (
        .sel(d),
        .d0(1'b1),  // d=0 -> output 1
        .d1(1'b0),  // d=1 -> output 0
        .y(not_d)
    );

    // mux_in[0] = function for ab=00:
    // output 0 only when c=0,d=0 else 1
    // implemented as mux2 select=c:
    // if c=0 output d else 1
    mux2 mux_in0 (
        .sel(c),
        .d0(d),
        .d1(1'b1),
        .y(mux_in[0])
    );

    // mux_in[1] = function for ab=01:
    // always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = function for ab=11:
    // 1 only when c=1,d=1 else 0
    // implemented as mux2 select=c:
    // if c=0 output 0 else d
    mux2 mux_in2 (
        .sel(c),
        .d0(1'b0),
        .d1(d),
        .y(mux_in[2])
    );

    // mux_in[3] = function for ab=10:
    // 1 except when c=0,d=1 (then 0)
    // which is: if c=0 output ~d else 1
    mux2 mux_in3 (
        .sel(c),
        .d0(not_d),
        .d1(1'b1),
        .y(mux_in[3])
    );
endmodule