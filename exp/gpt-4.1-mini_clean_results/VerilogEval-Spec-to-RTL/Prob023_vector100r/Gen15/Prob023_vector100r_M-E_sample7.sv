module BitRev10 (
    input  [9:0] in,
    output [9:0] out
);
    assign out[0] = in[9];
    assign out[1] = in[8];
    assign out[2] = in[7];
    assign out[3] = in[6];
    assign out[4] = in[5];
    assign out[5] = in[4];
    assign out[6] = in[3];
    assign out[7] = in[2];
    assign out[8] = in[1];
    assign out[9] = in[0];
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    wire [9:0] seg_in [0:9];
    wire [9:0] seg_out [0:9];

    // Split input into 10 segments of 10 bits each
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : input_segmentation
            assign seg_in[i] = in[i*10 +: 10];
        end
    endgenerate

    // Reverse each 10-bit segment individually
    generate
        for (i = 0; i < 10; i = i + 1) begin : bitrev_segments
            BitRev10 bitrev_inst (
                .in(seg_in[i]),
                .out(seg_out[i])
            );
        end
    endgenerate

    // Concatenate reversed segments in reversed order to form final output
    generate
        for (i = 0; i < 10; i = i + 1) begin : output_concat
            assign out[i*10 +: 10] = seg_out[9 - i];
        end
    endgenerate
endmodule