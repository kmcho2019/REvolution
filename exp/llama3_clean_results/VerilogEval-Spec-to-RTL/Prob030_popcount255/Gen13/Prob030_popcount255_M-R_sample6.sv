module population_count(
    input [7:0] in,
    output [7:0] out
);

    always @(*) begin
        out = $countones(in);
    end

endmodule

module hierarchical_adder(
    input [7:0] in [3:0],
    output [7:0] out
);

    wire [7:0] temp;
    assign temp = in[0] + in[1];
    assign out = temp + in[2] + in[3];

endmodule

module TopModule(
    input [254:0] in,
    output [7:0] out
);

    parameter NUM_SEGMENTS = 32;
    parameter SEGMENT_WIDTH = 8;

    wire [SEGMENT_WIDTH-1:0] segment [NUM_SEGMENTS-1:0];
    wire [SEGMENT_WIDTH-1:0] segment_count [NUM_SEGMENTS-1:0];
    wire [SEGMENT_WIDTH-1:0] group_sum [3:0];

    genvar i;
    generate
        for (i = 0; i < NUM_SEGMENTS; i++) begin
            if (i < NUM_SEGMENTS-1) begin
                assign segment[i] = in[(i*SEGMENT_WIDTH)+SEGMENT_WIDTH-1:i*SEGMENT_WIDTH];
            end else begin
                assign segment[i] = {1'b0, in[254:248]};
            end

            population_count u_population_count(
                .in(segment[i]),
                .out(segment_count[i])
            );
        end
    endgenerate

    assign group_sum[0] = segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3] +
                          segment_count[4] + segment_count[5] + segment_count[6] + segment_count[7];
    assign group_sum[1] = segment_count[8] + segment_count[9] + segment_count[10] + segment_count[11] +
                          segment_count[12] + segment_count[13] + segment_count[14] + segment_count[15];
    assign group_sum[2] = segment_count[16] + segment_count[17] + segment_count[18] + segment_count[19] +
                          segment_count[20] + segment_count[21] + segment_count[22] + segment_count[23];
    assign group_sum[3] = segment_count[24] + segment_count[25] + segment_count[26] + segment_count[27] +
                          segment_count[28] + segment_count[29] + segment_count[30] + segment_count[31];

    hierarchical_adder u_hierarchical_adder(
        .in(group_sum),
        .out(out)
    );

endmodule