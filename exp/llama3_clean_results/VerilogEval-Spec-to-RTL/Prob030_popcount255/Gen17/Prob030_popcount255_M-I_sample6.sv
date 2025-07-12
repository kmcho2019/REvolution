module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin
        assign segment[i] = in[i*8 +: 8];
    end
endgenerate

// Population counts for each segment using lookup table
reg [7:0] segment_count [31:0];

always @(*) begin
    for (int i = 0; i < 32; i = i + 1) begin
        segment_count[i] = $countones(segment[i]);
    end
end

// Final population count using hierarchical adder tree structure
wire [7:0] count;

assign count = segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3] + segment_count[4] + segment_count[5] + segment_count[6] + segment_count[7] + 
               segment_count[8] + segment_count[9] + segment_count[10] + segment_count[11] + segment_count[12] + segment_count[13] + segment_count[14] + segment_count[15] + 
               segment_count[16] + segment_count[17] + segment_count[18] + segment_count[19] + segment_count[20] + segment_count[21] + segment_count[22] + segment_count[23] + 
               segment_count[24] + segment_count[25] + segment_count[26] + segment_count[27] + segment_count[28] + segment_count[29] + segment_count[30] + segment_count[31];

// Assign the output
assign out = count;

endmodule