module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [7:0] stage1;
    wire [7:0] stage2;
    genvar i;

    // Stage 1: rotate right by 4 if ctrl[2] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage1_loop
            // Rotate right by 4
            localparam integer rotated_idx = (i + 4) % 8;
            assign stage1[i] = ctrl[2] ? in[rotated_idx] : in[i];
        end
    endgenerate

    // Stage 2: rotate right by 2 if ctrl[1] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage2_loop
            // Rotate right by 2
            localparam integer rotated_idx = (i + 2) % 8;
            assign stage2[i] = ctrl[1] ? stage1[rotated_idx] : stage1[i];
        end
    endgenerate

    // Stage 3: rotate right by 1 if ctrl[0] is set
    generate
        for (i = 0; i < 8; i = i + 1) begin : stage3_loop
            // Rotate right by 1
            localparam integer rotated_idx = (i + 1) % 8;
            assign out[i] = ctrl[0] ? stage2[rotated_idx] : stage2[i];
        end
    endgenerate

endmodule