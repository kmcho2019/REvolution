module population_count_segment(
    input [7:0] in,
    output [4:0] out
);
    always @(in) begin
        out = $countones(in);
    end
endmodule

module population_count_group(
    input [4:0] in [3:0],
    output [6:0] out
);
    assign out = in[0] + in[1] + in[2] + in[3];
endmodule

module TopModule(
    input [254:0] in,
    output [7:0] out
);
    parameter SEGMENT_SIZE = 8;
    parameter NUM_SEGMENTS = 32;
    parameter NUM_GROUPS = 8;

    wire [7:0] segments [NUM_SEGMENTS-1:0];
    wire [4:0] segment_counts [NUM_SEGMENTS-1:0];
    wire [6:0] group_sums [NUM_GROUPS-1:0];

    genvar i, j;
    for (i = 0; i < NUM_SEGMENTS; i++) begin
        assign segments[i] = in[(i*SEGMENT_SIZE)+SEGMENT_SIZE-1:i*SEGMENT_SIZE];
        population_count_segment segment_count_inst(
            .in(segments[i]),
            .out(segment_counts[i])
        );
    end

    for (j = 0; j < NUM_GROUPS; j++) begin
        assign group_sums[j] = segment_counts[j*4] + segment_counts[j*4+1] + segment_counts[j*4+2] + segment_counts[j*4+3];
        //population_count_group group_sum_inst(
        //    .in({segment_counts[j*4], segment_counts[j*4+1], segment_counts[j*4+2], segment_counts[j*4+3]}),
        //    .out(group_sums[j])
        //);
    end

    assign out = group_sums[0] + group_sums[1] + group_sums[2] + group_sums[3] + group_sums[4] + group_sums[5] + group_sums[6] + group_sums[7];

endmodule