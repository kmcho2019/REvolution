module Mux2to1 (
    input  wire [1:0] in,
    input  wire       sel,
    output wire       out
);
    assign out = in[sel];
endmodule

module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    wire [1:0] level1_out;

    // Two 2-to-1 muxes selecting pairs
    Mux2to1 mux_lower (.in(in[1:0]), .sel(sel[0]), .out(level1_out[0]));
    Mux2to1 mux_upper (.in(in[3:2]), .sel(sel[0]), .out(level1_out[1]));

    // Final 2-to-1 mux selecting between the above two
    Mux2to1 mux_final (.in(level1_out), .sel(sel[1]), .out(out));
endmodule

module Mux8to1 (
    input  wire [7:0] in,
    input  wire [2:0] sel,
    output wire       out
);
    wire [1:0] level1_out;

    // Two 4-to-1 muxes each handling 4 inputs
    Mux4to1 mux_lower (.in(in[3:0]), .sel(sel[1:0]), .out(level1_out[0]));
    Mux4to1 mux_upper (.in(in[7:4]), .sel(sel[1:0]), .out(level1_out[1]));

    // 2-to-1 mux selecting between the two 4-to-1 outputs
    Mux2to1 mux_final (.in(level1_out), .sel(sel[2]), .out(out));
endmodule

module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    wire [1:0] level1_out;

    // Two 8-to-1 muxes each handling 8 inputs
    Mux8to1 mux_lower (.in(in[7:0]),   .sel(sel[2:0]), .out(level1_out[0]));
    Mux8to1 mux_upper (.in(in[15:8]),  .sel(sel[2:0]), .out(level1_out[1]));

    // Final 2-to-1 mux selects between the two 8-to-1 outputs
    Mux2to1 mux_final (.in(level1_out), .sel(sel[3]), .out(out));
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    wire [15:0] level1_out;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : LEVEL1
            // Each Mux16to1 selects one bit from a 16-bit slice with sel[3:0]
            Mux16to1 u_mux16 (
                .in(in[i*16 +: 16]),
                .sel(sel[3:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    // Final Mux16to1 selects one bit from the 16 intermediate bits with sel[7:4]
    Mux16to1 u_mux16_final (
        .in(level1_out),
        .sel(sel[7:4]),
        .out(out)
    );
endmodule