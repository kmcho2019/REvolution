module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    assign out = in[sel];
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [15:0] level1_out;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1_MUXES
            Mux16to1 u_mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    Mux16to1 u_final_mux (
        .in(level1_out),
        .sel(sel[7:4]),
        .out(out)
    );
endmodule