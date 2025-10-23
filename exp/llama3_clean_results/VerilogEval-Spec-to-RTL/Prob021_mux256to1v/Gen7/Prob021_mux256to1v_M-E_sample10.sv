module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Define the segment size for each level of the hierarchy
    localparam SEGMENT_SIZE = 4;

    // Define the number of levels in the hierarchy
    localparam NUM_LEVELS = 8;

    // Create an array to store the outputs of each level
    wire [3:0] level_out [NUM_LEVELS-1:0];

    // Level 1: Select 4-bit segments from the input vector
    assign level_out[0] = in[(sel * SEGMENT_SIZE) +: SEGMENT_SIZE];

    // Remaining levels: Select the final 4-bit output
    assign out = level_out[0];

endmodule