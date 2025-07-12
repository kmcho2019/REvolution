module TopModule(
    input [254:0] in,
    output [7:0] out
);

    // Define the number of segments and sub-segments
    localparam NUM_SEGMENTS = 16;
    localparam NUM_SUB_SEGMENTS = 16;

    // Define the width of each sub-segment
    localparam SUB_SEGMENT_WIDTH = 16;

    // Define the LUT for counting units
    reg [7:0] lut [2**SUB_SEGMENT_WIDTH-1:0];

    // Initialize the LUT
    initial begin
        for (int i = 0; i < 2**SUB_SEGMENT_WIDTH; i++) begin
            lut[i] = $countones(i);
        end
    end

    // Define the counting units
    reg [7:0] count [NUM_SEGMENTS-1:0];

    // Generate the counting units
    genvar i;
    generate
        for (i = 0; i < NUM_SEGMENTS; i++) begin
            // Define the sub-segment
            reg [SUB_SEGMENT_WIDTH-1:0] sub_segment;

            // Assign the sub-segment
            assign sub_segment = in[(i*SUB_SEGMENT_WIDTH)+:SUB_SEGMENT_WIDTH];

            // Define the counting unit
            assign count[i] = lut[sub_segment];
        end
    endgenerate

    // Define the pipeline stages
    reg [7:0] pipeline [NUM_SEGMENTS-1:0];

    // Generate the pipeline stages
    generate
        for (i = 0; i < NUM_SEGMENTS; i++) begin
            // Define the pipeline stage
            assign pipeline[i] = count[i];
        end
    endgenerate

    // Define the final sum
    reg [7:0] final_sum;

    // Calculate the final sum
    assign final_sum = pipeline[0] + pipeline[1] + pipeline[2] + pipeline[3] + pipeline[4] + pipeline[5] + pipeline[6] + pipeline[7] + pipeline[8] + pipeline[9] + pipeline[10] + pipeline[11] + pipeline[12] + pipeline[13] + pipeline[14] + pipeline[15];

    // Assign the output
    assign out = final_sum;

endmodule