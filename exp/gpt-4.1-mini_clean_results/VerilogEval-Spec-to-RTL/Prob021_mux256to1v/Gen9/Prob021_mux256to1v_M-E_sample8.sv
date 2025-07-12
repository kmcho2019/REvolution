module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Intermediate wires: 16 outputs of first stage (each 4 bits)
    wire [3:0] stage1_out [15:0];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_stage1
            // Extract 64 bits (16 words x 4 bits) per group
            wire [63:0] group = in[i*64 +: 64];
            // Instantiate 16-to-1 mux with 4-bit wide data
            Mux16to1_4bit mux16 (
                .in(group),
                .sel(sel[3:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Final stage: 16-to-1 mux selecting one of 16 4-bit inputs
    Mux16to1_4bit mux_final (
        .in({stage1_out[15], stage1_out[14], stage1_out[13], stage1_out[12],
             stage1_out[11], stage1_out[10], stage1_out[9],  stage1_out[8],
             stage1_out[7],  stage1_out[6],  stage1_out[5],  stage1_out[4],
             stage1_out[3],  stage1_out[2],  stage1_out[1],  stage1_out[0]}),
        .sel(sel[7:4]),
        .out(out)
    );

endmodule

// 16-to-1 multiplexer, 4-bit wide
module Mux16to1_4bit (
    input  wire [63:0] in,   // 16 inputs of 4 bits each packed
    input  wire [3:0]  sel,
    output wire [3:0]  out
);
    // Slice inputs as array of 16 4-bit words
    wire [3:0] inputs [15:0];
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : slice_inputs
            assign inputs[j] = in[j*4 +: 4];
        end
    endgenerate

    assign out = inputs[sel];

endmodule