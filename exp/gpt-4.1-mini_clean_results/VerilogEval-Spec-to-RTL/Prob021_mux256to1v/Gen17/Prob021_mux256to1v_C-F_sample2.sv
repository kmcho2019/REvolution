module Mux16to1_4bit (
    input  wire [16*4-1:0] in, // 16 inputs, each 4-bit wide
    input  wire [3:0]      sel,
    output wire [3:0]      out
);
    // Select 4-bit slice based on sel
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select
    output wire [3:0]    out   // 4-bit output
);

    // Stage 1: 16 multiplexers, each selects among 16 inputs (64 bits)
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_MUX16
            // Directly slice 64 bits (16 inputs * 4 bits) for each mux
            wire [63:0] in_slice_16 = in[i*64 +: 64];
            Mux16to1_4bit u_mux16to1 (
                .in(in_slice_16),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Concatenate stage1 outputs to form input vector for final mux
    wire [64-1:0] stage1_flat;
    generate
        for (i = 0; i < 16; i = i + 1) begin : STAGE1_PACK
            assign stage1_flat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    // Stage 2: Final 16-to-1 mux selects final 4-bit output
    Mux16to1_4bit u_mux16to1_final (
        .in(stage1_flat),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule