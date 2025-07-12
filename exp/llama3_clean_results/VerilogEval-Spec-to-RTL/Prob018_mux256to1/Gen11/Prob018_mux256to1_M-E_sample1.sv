module TopModule(
    input [255:0] in, // 256-bit input vector
    input [7:0] sel, // 8-bit select signal
    output reg out // 1-bit output
);

    // Define the segment size
    parameter SEGMENT_SIZE = 16;

    // Define the number of segments
    parameter NUM_SEGMENTS = 256 / SEGMENT_SIZE;

    // Define the number of levels in the hierarchy
    parameter NUM_LEVELS = $clog2(NUM_SEGMENTS);

    // Define the wires for each level
    wire [NUM_SEGMENTS-1:0] level1_out;
    wire [NUM_SEGMENTS/2-1:0] level2_out;
    wire [NUM_SEGMENTS/4-1:0] level3_out;
    wire [NUM_SEGMENTS/8-1:0] level4_out;
    wire [NUM_SEGMENTS/16-1:0] level5_out;
    wire [NUM_SEGMENTS/32-1:0] level6_out;
    wire [NUM_SEGMENTS/64-1:0] level7_out;
    wire [NUM_SEGMENTS/128-1:0] level8_out;

    // Level 1: Select between segments
    genvar i;
    generate
        for (i = 0; i < NUM_SEGMENTS; i++) begin
            assign level1_out[i] = in[(i*SEGMENT_SIZE) + (sel[3:0])];
        end
    endgenerate

    // Level 2: Select between segments
    genvar j;
    generate
        for (j = 0; j < NUM_SEGMENTS/2; j++) begin
            assign level2_out[j] = (sel[4] == 1'b0) ? level1_out[j*2] : level1_out[j*2 + 1];
        end
    endgenerate

    // Level 3: Select between segments
    genvar k;
    generate
        for (k = 0; k < NUM_SEGMENTS/4; k++) begin
            assign level3_out[k] = (sel[5] == 1'b0) ? level2_out[k*2] : level2_out[k*2 + 1];
        end
    endgenerate

    // Level 4: Select between segments
    genvar l;
    generate
        for (l = 0; l < NUM_SEGMENTS/8; l++) begin
            assign level4_out[l] = (sel[6] == 1'b0) ? level3_out[l*2] : level3_out[l*2 + 1];
        end
    endgenerate

    // Level 5: Select between segments
    genvar m;
    generate
        for (m = 0; m < NUM_SEGMENTS/16; m++) begin
            assign level5_out[m] = (sel[7] == 1'b0) ? level4_out[m*2] : level4_out[m*2 + 1];
        end
    endgenerate

    // Assign the output
    assign out = level5_out[0];

endmodule