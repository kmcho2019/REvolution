module Mux2to1 (
    input  wire sel,
    input  wire d0,
    input  wire d1,
    output wire y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);

    // mux_in[0] = c ? 1 : d;
    Mux2to1 mux0 (
        .sel(c),
        .d0(d),
        .d1(1'b1),
        .y(mux_in[0])
    );

    // mux_in[1] = 0 (constant zero)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? d : 0;
    Mux2to1 mux2 (
        .sel(c),
        .d0(1'b0),
        .d1(d),
        .y(mux_in[2])
    );

    // mux_in[3] = d ? c : 1;
    Mux2to1 mux3 (
        .sel(d),
        .d0(1'b1),
        .d1(c),
        .y(mux_in[3])
    );

endmodule