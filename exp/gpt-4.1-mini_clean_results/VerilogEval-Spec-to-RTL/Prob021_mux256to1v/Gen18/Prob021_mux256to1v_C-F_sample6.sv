module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Parameterized function for 4-to-1 mux (4-bit wide)
    function [3:0] mux4to1_4bit;
        input [4*4-1:0] inputs;  // concatenated 4 inputs x 4 bits each
        input [1:0]     sel;
        begin
            case (sel)
                2'd0: mux4to1_4bit = inputs[ 3: 0];
                2'd1: mux4to1_4bit = inputs[ 7: 4];
                2'd2: mux4to1_4bit = inputs[11: 8];
                2'd3: mux4to1_4bit = inputs[15:12];
                default: mux4to1_4bit = 4'b0000;
            endcase
        end
    endfunction

    // Stage 1: 64 mux4to1_4bit selecting among 4 inputs (sel[1:0])
    wire [3:0] stage1_out [63:0];
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : STAGE1
            wire [15:0] inputs_stage1 = in[i*16 +: 16]; // 4 inputs * 4 bits
            assign stage1_out[i] = mux4to1_4bit(inputs_stage1, sel[1:0]);
        end
    endgenerate

    // Flatten stage1_out for stage2 input wiring (64 x 4 bits = 256 bits)
    wire [255:0] stage1_flat;
    generate
        for (i = 0; i < 64; i = i + 1) begin : FLATTEN_STAGE1
            assign stage1_flat[i*4 +: 4] = stage1_out[i];
        end
    endgenerate

    // Stage 2: 16 mux4to1_4bit selecting among 4 inputs from stage1_out (sel[3:2])
    wire [3:0] stage2_out [15:0];
    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : STAGE2
            wire [15:0] inputs_stage2 = stage1_flat[j*16 +: 16]; // 4 inputs * 4 bits
            assign stage2_out[j] = mux4to1_4bit(inputs_stage2, sel[3:2]);
        end
    endgenerate

    // Flatten stage2_out for stage3 input wiring (16 x 4 bits = 64 bits)
    wire [63:0] stage2_flat;
    generate
        for (j = 0; j < 16; j = j + 1) begin : FLATTEN_STAGE2
            assign stage2_flat[j*4 +: 4] = stage2_out[j];
        end
    endgenerate

    // Stage 3: 4 mux4to1_4bit selecting among 4 inputs from stage2_out (sel[5:4])
    wire [3:0] stage3_out [3:0];
    genvar k;
    generate
        for (k = 0; k < 4; k = k + 1) begin : STAGE3
            wire [15:0] inputs_stage3 = stage2_flat[k*16 +: 16]; // 4 inputs * 4 bits
            assign stage3_out[k] = mux4to1_4bit(inputs_stage3, sel[5:4]);
        end
    endgenerate

    // Flatten stage3_out for stage4 input wiring (4 x 4 bits = 16 bits)
    wire [15:0] stage3_flat;
    generate
        for (k = 0; k < 4; k = k + 1) begin : FLATTEN_STAGE3
            assign stage3_flat[k*4 +: 4] = stage3_out[k];
        end
    endgenerate

    // Stage 4: final mux4to1_4bit selecting among 4 inputs from stage3_out (sel[7:6])
    assign out = mux4to1_4bit(stage3_flat, sel[7:6]);

endmodule