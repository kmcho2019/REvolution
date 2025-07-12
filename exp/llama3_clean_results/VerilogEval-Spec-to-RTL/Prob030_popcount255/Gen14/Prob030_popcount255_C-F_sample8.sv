module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments using generate
genvar i;
generate
    for (i = 0; i < 32; i++) begin
        if (i < 31) begin
            assign segment[i] = in[i*8 +: 8];
        end else begin
            assign segment[i] = {1'b0, in[254:248]};
        end
    end
endgenerate

// Population counts for each segment
wire [4:0] segment_count [31:0];

// Assign the population counts using generate
generate
    for (i = 0; i < 32; i++) begin
        assign segment_count[i] = $countones(segment[i]);
    end
endgenerate

// Hierarchical adder structure
wire [7:0] count_level1 [15:0];
generate
    for (genvar j = 0; j < 16; j++) begin
        assign count_level1[j] = segment_count[j*2] + segment_count[j*2 + 1];
    end
endgenerate

wire [7:0] count_level2 [7:0];
generate
    for (genvar j = 0; j < 8; j++) begin
        assign count_level2[j] = count_level1[j*2] + count_level1[j*2 + 1];
    end
endgenerate

wire [7:0] count_level3 [3:0];
generate
    for (genvar j = 0; j < 4; j++) begin
        assign count_level3[j] = count_level2[j*2] + count_level2[j*2 + 1];
    end
endgenerate

wire [7:0] count_level4 [1:0];
generate
    for (genvar j = 0; j < 2; j++) begin
        assign count_level4[j] = count_level3[j*2] + count_level3[j*2 + 1];
    end
endgenerate

// Final sum
wire [7:0] count;
assign count = count_level4[0] + count_level4[1];

// Assign the output
assign out = count;

endmodule