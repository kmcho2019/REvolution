module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Define the size of each segment
localparam SEGMENT_SIZE = 8;

// Define the number of segments
localparam NUM_SEGMENTS = 255 / SEGMENT_SIZE + 1;

// Define the lookup table for population count
reg [7:0] lut [2**SEGMENT_SIZE - 1:0];

// Initialize the lookup table
initial begin
    for (int i = 0; i < 2**SEGMENT_SIZE; i++) begin
        lut[i] = $countones(i);
    end
end

// Calculate the population count for each segment
wire [7:0] segment_count [NUM_SEGMENTS - 1:0];

// Assign the population counts using generate
genvar i;
generate
    for (i = 0; i < NUM_SEGMENTS; i++) begin
        if (i < NUM_SEGMENTS - 1) begin
            assign segment_count[i] = lut[in[i*SEGMENT_SIZE +: SEGMENT_SIZE]];
        end else begin
            assign segment_count[i] = lut[{1'b0, in[254:248]}];
        end
    end
endgenerate

// Calculate the final population count
wire [7:0] count;
assign count = segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3] +
               segment_count[4] + segment_count[5] + segment_count[6] + segment_count[7] +
               segment_count[8] + segment_count[9] + segment_count[10] + segment_count[11] +
               segment_count[12] + segment_count[13] + segment_count[14] + segment_count[15] +
               segment_count[16] + segment_count[17] + segment_count[18] + segment_count[19] +
               segment_count[20] + segment_count[21] + segment_count[22] + segment_count[23] +
               segment_count[24] + segment_count[25] + segment_count[26] + segment_count[27] +
               segment_count[28] + segment_count[29] + segment_count[30] + segment_count[31];

// Assign the output
assign out = count;

endmodule