module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [15:0] mid_out [15:0];

    // First level of multiplexers (16-to-1)
    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            mux16to1 mux_i(
                .in(in[(i * 64) +: 64]),
                .sel(sel[3:0]),
                .out(mid_out[i])
            );
        end
    endgenerate

    // Second level of multiplexers (16-to-1)
    mux16to1 mux_final(
        .in({mid_out[15], mid_out[14], mid_out[13], mid_out[12], mid_out[11], mid_out[10], mid_out[9], mid_out[8], mid_out[7], mid_out[6], mid_out[5], mid_out[4], mid_out[3], mid_out[2], mid_out[1], mid_out[0]}),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule

module mux16to1(
    input  [63:0] in,
    input  [3:0] sel,
    output [3:0] out
);

    assign out = in[(sel * 4) +: 4];

endmodule