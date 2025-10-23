module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 0: Rotate left by 4 if ctrl[2] = 1
    wire [7:0] stage0;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage0_logic
            // Rotate left by 4 with wrap-around
            assign stage0[i] = ctrl[2] ? in[(i+4) % 8] : in[i];
        end
    endgenerate

    // Stage 1: Rotate left by 2 if ctrl[1] = 1
    wire [7:0] stage1;
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_logic
            // Rotate left by 2 with wrap-around
            assign stage1[i] = ctrl[1] ? stage0[(i+2) % 8] : stage0[i];
        end
    endgenerate

    // Stage 2: Rotate left by 1 if ctrl[0] = 1
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_logic
            // Rotate left by 1 with wrap-around
            assign out[i] = ctrl[0] ? stage1[(i+1) % 8] : stage1[i];
        end
    endgenerate

endmodule