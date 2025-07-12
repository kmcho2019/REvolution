module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 16 segments of 16 bits (to reduce the number of additions)
wire [15:0] segment [15:0];

// Assign the segments
genvar i;
for (i = 0; i < 16; i++) begin
    assign segment[i] = in[(i*16)+15:i*16];
end

// Population counts for each segment
wire [4:0] segment_count [15:0];

// Assign the population counts using a simple counter for each 16-bit segment
for (genvar i = 0; i < 16; i++) begin
    wire [15:0] segment_in = segment[i];
    reg [4:0] count;
    always @(posedge segment_in) begin
        count = 0;
        for (int j = 0; j < 16; j++) begin
            if (segment_in[j] == 1'b1) begin
                count = count + 1'b1;
            end
        end
    end
    assign segment_count[i] = count;
end

// Hierarchical population count with reduced levels
wire [7:0] count_level1 [7:0];
assign count_level1[0]  = segment_count[0]  + segment_count[1];
assign count_level1[1]  = segment_count[2]  + segment_count[3];
assign count_level1[2]  = segment_count[4]  + segment_count[5];
assign count_level1[3]  = segment_count[6]  + segment_count[7];
assign count_level1[4]  = segment_count[8]  + segment_count[9];
assign count_level1[5]  = segment_count[10] + segment_count[11];
assign count_level1[6]  = segment_count[12] + segment_count[13];
assign count_level1[7]  = segment_count[14] + segment_count[15];

wire [7:0] count_level2 [3:0];
assign count_level2[0] = count_level1[0] + count_level1[1];
assign count_level2[1] = count_level1[2] + count_level1[3];
assign count_level2[2] = count_level1[4] + count_level1[5];
assign count_level2[3] = count_level1[6] + count_level1[7];

wire [7:0] count;
assign count = count_level2[0] + count_level2[1] + count_level2[2] + count_level2[3];

// Assign the output
assign out = count;

endmodule