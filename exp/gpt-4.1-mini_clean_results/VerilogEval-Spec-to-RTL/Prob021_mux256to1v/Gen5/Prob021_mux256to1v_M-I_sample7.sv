module Mux16to1_4bit (
    input  [16*4-1:0] in, // 16 inputs, each 4-bit wide
    input  [3:0]      sel,
    output [3:0]      out
);
    // Select 4-bit slice indexed by sel
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // First stage: 16 multiplexers of 16-to-1
    // Each mux selects one of 16 4-bit inputs (64 bits total per mux)
    // We'll have 16 such muxes to cover 256 inputs total

    wire [3:0] stage1_out [0:15];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1
            // Extract 64 bits for each 16-to-1 mux (16 x 4-bit inputs)
            wire [63:0] in_slice;
            assign in_slice = in[(i*64) +: 64];
            Mux16to1_4bit u_mux16to1 (
                .in(in_slice),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Second stage: one 16-to-1 mux selecting among stage1 outputs
    // Flatten stage1_out array to a single 64-bit vector
    wire [63:0] stage1_concat;
    generate
        for (i = 0; i < 16; i = i + 1) begin : CONCAT_STAGE1
            assign stage1_concat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    Mux16to1_4bit u_mux_final (
        .in(stage1_concat),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule