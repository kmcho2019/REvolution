module SegmentCounter(
    input [7:0] in,
    output [4:0] out
);
    assign out = $countones(in);
endmodule

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
    wire [4:0] segment_count [31:0];

    // Instantiate SegmentCounter for each segment
    for (genvar i = 0; i < 32; i++) begin
        SegmentCounter sc(
           .in(segment[i]),
           .out(segment_count[i])
        );
    end

    // Sum up the population counts using a hierarchical adder tree
    wire [6:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8;
    assign sum1 = segment_count[0] + segment_count[1] + segment_count[2] + segment_count[3];
    assign sum2 = segment_count[4] + segment_count[5] + segment_count[6] + segment_count[7];
    assign sum3 = segment_count[8] + segment_count[9] + segment_count[10] + segment_count[11];
    assign sum4 = segment_count[12] + segment_count[13] + segment_count[14] + segment_count[15];
    assign sum5 = segment_count[16] + segment_count[17] + segment_count[18] + segment_count[19];
    assign sum6 = segment_count[20] + segment_count[21] + segment_count[22] + segment_count[23];
    assign sum7 = segment_count[24] + segment_count[25] + segment_count[26] + segment_count[27];
    assign sum8 = segment_count[28] + segment_count[29] + segment_count[30] + segment_count[31];

    wire [7:0] sum12, sum34, sum56, sum78;
    assign sum12 = sum1 + sum2;
    assign sum34 = sum3 + sum4;
    assign sum56 = sum5 + sum6;
    assign sum78 = sum7 + sum8;

    wire [7:0] sum1234, sum5678;
    assign sum1234 = sum12 + sum34;
    assign sum5678 = sum56 + sum78;

    wire [7:0] count;
    assign count = sum1234 + sum5678;

    // Assign the output
    assign out = count;

endmodule