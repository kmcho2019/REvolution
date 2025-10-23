module Mux4to1 (
    input  wire [3:0] in,
    input  wire [1:0] sel,
    output wire       out
);
    // Simple direct indexed 4-to-1 mux
    assign out = in[sel];
endmodule

module Mux16to1 (
    input  wire [15:0] in,
    input  wire [3:0]  sel,
    output wire        out
);
    // Build 16-to-1 mux as a balanced two-level tree of 4-to-1 muxes
    wire [3:0] level1_out;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : first_stage
            Mux4to1 mux4_inst (
                .in(in[i*4 +: 4]),
                .sel(sel[1:0]),
                .out(level1_out[i])
            );
        end
    endgenerate

    Mux4to1 mux4_final (
        .in(level1_out),
        .sel(sel[3:2]),
        .out(out)
    );
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Directly select the bit from the 256-bit input vector using sel
    assign out = in[sel];
endmodule