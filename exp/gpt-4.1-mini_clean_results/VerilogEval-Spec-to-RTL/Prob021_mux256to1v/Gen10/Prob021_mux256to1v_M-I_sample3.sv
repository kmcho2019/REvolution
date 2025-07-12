module Mux64to1_4bit (
    input  [64*4-1:0] in, // 64 inputs, each 4-bit wide
    input  [5:0]      sel,
    output [3:0]      out
);
    assign out = in[sel*4 +: 4];
endmodule

module Mux4to1_4bit (
    input  [4*4-1:0] in, // 4 inputs, each 4-bit wide
    input  [1:0]     sel,
    output [3:0]     out
);
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Partition the 256 inputs into 4 groups of 64 inputs (each 4 bits)
    wire [3:0] stage1_out [0:3];

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : STAGE1
            wire [255:0] in_slice;
            assign in_slice = in[(i*256) +: 256]; // 64*4=256 bits per group
            Mux64to1_4bit u_mux64to1 (
                .in(in_slice),
                .sel(sel[5:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Final stage: 4-to-1 mux selects among stage1 outputs
    wire [15:0] stage1_concat;
    generate
        for (i = 0; i < 4; i = i + 1) begin : CONCAT_STAGE1
            assign stage1_concat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    Mux4to1_4bit u_mux4to1 (
        .in(stage1_concat),
        .sel(sel[7:6]),
        .out(out)
    );
endmodule