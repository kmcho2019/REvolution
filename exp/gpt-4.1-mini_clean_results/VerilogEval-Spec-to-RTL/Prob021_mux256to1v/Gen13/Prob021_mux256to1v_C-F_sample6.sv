module Mux4to1_4bit (
    input  wire [15:0] in,    // 4 inputs × 4 bits = 16 bits packed {in3,in2,in1,in0}
    input  wire [1:0]  sel,
    output wire [3:0]  out
);
    // Select 4 bits corresponding to sel index
    assign out = in[sel*4 +: 4];
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Stage 1: 64 muxes 4-to-1 selecting from in[...]
    // Each mux inputs: 4 inputs * 4 bits = 16 bits slice from 'in'
    // The 256 inputs are grouped into 64 groups of 4 inputs each:
    // The index for the inputs to stage 1 mux i (0..63) is: input indices (i*4 + 0..3)
    // So bits selected from 'in' are [ (i*4 + sel)*4 +: 4 ] for sel=0..3 in the mux inputs.

    wire [3:0] stage1_out [0:63];

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : stage1_loop
            // Build the 16-bit input to mux: concatenation of 4 inputs of 4 bits each
            wire [15:0] mux_in;
            assign mux_in = {
                in[(i*4 + 3)*4 +: 4],   // input 3
                in[(i*4 + 2)*4 +: 4],   // input 2
                in[(i*4 + 1)*4 +: 4],   // input 1
                in[(i*4 + 0)*4 +: 4]    // input 0
            };
            Mux4to1_4bit u_mux1 (
                .in(mux_in),
                .sel(sel[1:0]),
                .out(stage1_out[i])
            );
        end
    endgenerate

    // Stage 2: 16 muxes 4-to-1 selecting from stage1_out
    // Each mux inputs 4 stage1 outputs (each 4-bit)
    // Indices: stage1_out[ j*4 + 0..3 ], j=0..15

    wire [3:0] stage2_out [0:15];

    generate
        for (i = 0; i < 16; i = i + 1) begin : stage2_loop
            wire [15:0] mux_in;
            assign mux_in = {
                stage1_out[i*4 + 3],
                stage1_out[i*4 + 2],
                stage1_out[i*4 + 1],
                stage1_out[i*4 + 0]
            };
            Mux4to1_4bit u_mux2 (
                .in(mux_in),
                .sel(sel[3:2]),
                .out(stage2_out[i])
            );
        end
    endgenerate

    // Stage 3: 4 muxes 4-to-1 selecting from stage2_out
    // Inputs: stage2_out[ k*4 + 0..3 ], k=0..3

    wire [3:0] stage3_out [0:3];

    generate
        for (i = 0; i < 4; i = i + 1) begin : stage3_loop
            wire [15:0] mux_in;
            assign mux_in = {
                stage2_out[i*4 + 3],
                stage2_out[i*4 + 2],
                stage2_out[i*4 + 1],
                stage2_out[i*4 + 0]
            };
            Mux4to1_4bit u_mux3 (
                .in(mux_in),
                .sel(sel[5:4]),
                .out(stage3_out[i])
            );
        end
    endgenerate

    // Final Stage: single 4-to-1 mux selecting from stage3_out[0..3]
    wire [15:0] final_mux_in = {
        stage3_out[3],
        stage3_out[2],
        stage3_out[1],
        stage3_out[0]
    };

    Mux4to1_4bit u_mux_final (
        .in(final_mux_in),
        .sel(sel[7:6]),
        .out(out)
    );

endmodule