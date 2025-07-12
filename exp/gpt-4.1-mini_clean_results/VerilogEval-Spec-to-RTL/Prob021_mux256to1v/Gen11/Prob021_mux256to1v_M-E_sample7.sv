module Mux2to1_4bit (
    input  wire [3:0] in0,
    input  wire [3:0] in1,
    input  wire       sel,
    output wire [3:0] out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Unpack input vector into array of 256 4-bit inputs
    wire [3:0] inputs_array [0:255];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : UNPACK_INPUTS
            assign inputs_array[i] = in[i*4 +: 4];
        end
    endgenerate

    // Declare 8 stages of intermediate wires:
    // Stage 0: 256 inputs, Stage 1: 128 outputs, ..., Stage 7: 2 outputs
    // We'll store each stage's outputs in an array of wires:
    // Use a two-dimensional array is not supported in all tools, so use a packed array of wires.
    // Since sizes vary per stage, create multiple wire vectors.

    // Declare wires for each stage:
    // Maximum width stage 0 is 256, next 128, ... down to 1 output at stage 8 (final output)
    // We'll store only stages 1 to 8 in wires, stage 0 is inputs_array.

    // Stage indices: 0..8, where stage 8 output is final output out

    // For clarity, stage_sizes:
    // stage 0: 256 (inputs_array)
    // stage 1: 128
    // stage 2: 64
    // stage 3: 32
    // stage 4: 16
    // stage 5: 8
    // stage 6: 4
    // stage 7: 2
    // stage 8: 1 (final)

    // We'll create wires for stages 1 through 7 (stage 8 is final output).

    // Using arrays of wires:
    // wire [3:0] stage_outputs[N];

    // To simplify code, use generate loops with local arrays.

    // We'll store intermediate results in localparams inside a generate block.

    // For the recursive generate, store intermediate results in a local array variable (via generate).

    // Implement the binary tree muxing using nested generate loops.

    // To handle stages, create a generate block with a for-loop over stages, inside another for-loop over muxes at each stage.

    // First create storage for stage outputs.

    // To implement this cleanly, we use a recursive generate block with separate arrays for each stage.

    // Implementing combinational logic with arrays of wires:
    // We'll use a multi-dimensional wire array, indexed [stage][index], but as Verilog does not support multi-dimensional arrays of wires easily,
    // we'll define separate wire arrays per stage.

    // Define wires for stages 1 to 7:

    wire [3:0] stage1 [0:127];
    wire [3:0] stage2 [0:63];
    wire [3:0] stage3 [0:31];
    wire [3:0] stage4 [0:15];
    wire [3:0] stage5 [0:7];
    wire [3:0] stage6 [0:3];
    wire [3:0] stage7 [0:1];

    // Instantiate muxes for stage 1:
    generate
        for (i = 0; i < 128; i = i + 1) begin : STAGE1_MUXES
            Mux2to1_4bit mux2to1_inst (
                .in0(inputs_array[2*i]),
                .in1(inputs_array[2*i+1]),
                .sel(sel[0]),
                .out(stage1[i])
            );
        end
    endgenerate

    // Stage 2 muxes:
    genvar j;
    generate
        for (j = 0; j < 64; j = j + 1) begin : STAGE2_MUXES
            Mux2to1_4bit mux2to1_inst (
                .in0(stage1[2*j]),
                .in1(stage1[2*j+1]),
                .sel(sel[1]),
                .out(stage2[j])
            );
        end
    endgenerate

    // Stage 3 muxes:
    genvar k;
    generate
        for (k = 0; k < 32; k = k + 1) begin : STAGE3_MUXES
            Mux2to1_4bit mux2to1_inst (
                .in0(stage2[2*k]),
                .in1(stage2[2*k+1]),
                .sel(sel[2]),
                .out(stage3[k])
            );
        end
    endgenerate

    // Stage 4 muxes:
    genvar l;
    generate
        for (l = 0; l < 16; l = l + 1) begin : STAGE4_MUXES
            Mux2to1_4bit mux2to1_inst (
                .in0(stage3[2*l]),
                .in1(stage3[2*l+1]),
                .sel(sel[3]),
                .out(stage4[l])
            );
        end
    endgenerate

    // Stage 5 muxes:
    genvar m;
    generate
        for (m = 0; m < 8; m = m + 1) begin : STAGE5_MUXES
            Mux2to1_4bit mux2to1_inst (
                .in0(stage4[2*m]),
                .in1(stage4[2*m+1]),
                .sel(sel[4]),
                .out(stage5[m])
            );
        end
    endgenerate

    // Stage 6 muxes:
    genvar n;
    generate
        for (n = 0; n < 4; n = n + 1) begin : STAGE6_MUXES
            Mux2to1_4bit mux2to1_inst (
                .in0(stage5[2*n]),
                .in1(stage5[2*n+1]),
                .sel(sel[5]),
                .out(stage6[n])
            );
        end
    endgenerate

    // Stage 7 muxes:
    genvar o;
    generate
        for (o = 0; o < 2; o = o + 1) begin : STAGE7_MUXES
            Mux2to1_4bit mux2to1_inst (
                .in0(stage6[2*o]),
                .in1(stage6[2*o+1]),
                .sel(sel[6]),
                .out(stage7[o])
            );
        end
    endgenerate

    // Stage 8 (final mux):
    Mux2to1_4bit mux2to1_final (
        .in0(stage7[0]),
        .in1(stage7[1]),
        .sel(sel[7]),
        .out(out)
    );

endmodule