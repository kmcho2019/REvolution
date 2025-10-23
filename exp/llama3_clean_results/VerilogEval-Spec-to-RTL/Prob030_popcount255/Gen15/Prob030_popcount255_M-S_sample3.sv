module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Divide the input into 32 segments of 8 bits
wire [7:0] segment [31:0];

// Assign the segments
genvar i;
for (i = 0; i < 32; i++) begin
    if (i == 31) begin
        assign segment[i] = {1'b0, in[254:248]};
    end else begin
        assign segment[i] = in[(i*8)+7:i*8];
    end
end

// Population counts for each segment
wire [7:0] segment_count [31:0];

// Assign the population counts
for (genvar i = 0; i < 32; i++) begin
    assign segment_count[i] = $countones(segment[i]);
end

// First stage of adders
wire [8:0] count_stage1 [3:0];
assign count_stage1[0] = {1'b0, segment_count[0]} + {1'b0, segment_count[1]} + {1'b0, segment_count[2]} + {1'b0, segment_count[3]} + {1'b0, segment_count[4]} + {1'b0, segment_count[5]} + {1'b0, segment_count[6]} + {1'b0, segment_count[7]};
assign count_stage1[1] = {1'b0, segment_count[8]} + {1'b0, segment_count[9]} + {1'b0, segment_count[10]} + {1'b0, segment_count[11]} + {1'b0, segment_count[12]} + {1'b0, segment_count[13]} + {1'b0, segment_count[14]} + {1'b0, segment_count[15]};
assign count_stage1[2] = {1'b0, segment_count[16]} + {1'b0, segment_count[17]} + {1'b0, segment_count[18]} + {1'b0, segment_count[19]} + {1'b0, segment_count[20]} + {1'b0, segment_count[21]} + {1'b0, segment_count[22]} + {1'b0, segment_count[23]};
assign count_stage1[3] = {1'b0, segment_count[24]} + {1'b0, segment_count[25]} + {1'b0, segment_count[26]} + {1'b0, segment_count[27]} + {1'b0, segment_count[28]} + {1'b0, segment_count[29]} + {1'b0, segment_count[30]} + {1'b0, segment_count[31]};

// Second stage of adders
wire [9:0] count_stage2 [1:0];
assign count_stage2[0] = count_stage1[0] + count_stage1[1];
assign count_stage2[1] = count_stage1[2] + count_stage1[3];

// Third stage of adders
wire [10:0] count_stage3;
assign count_stage3 = count_stage2[0] + count_stage2[1];

// Final stage of adders
wire [7:0] count;
assign count = count_stage3[7:0];

// Assign the output
assign out = count;

endmodule