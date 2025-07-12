module Mux8to1 (
    input  [7:0] d0,
    input  [7:0] d1,
    input        sel,
    output [7:0] y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Use two muxes with fixed selects:
    // out_lo gets in[7:0], so sel=0 to pick d0 = in[7:0]
    // out_hi gets in[15:8], so sel=1 to pick d1 = in[15:8]

    // For out_lo: d0=in[7:0], d1=in[7:0], sel=0 (always select d0)
    // For out_hi: d0=in[15:8], d1=in[15:8], sel=1 (always select d1)

    Mux8to1 mux_lo (
        .d0(in[7:0]),
        .d1(in[7:0]),
        .sel(1'b0),
        .y(out_lo)
    );

    Mux8to1 mux_hi (
        .d0(in[15:8]),
        .d1(in[15:8]),
        .sel(1'b1),
        .y(out_hi)
    );

endmodule