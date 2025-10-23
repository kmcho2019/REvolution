module BitRev10 (
    input  [9:0] in,
    output [9:0] out
);
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9]};
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    // Break input into 10 segments of 10 bits each
    wire [9:0] segments_in [9:0];
    wire [9:0] segments_out [9:0];

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment_extract
            assign segments_in[i] = in[i*10 +: 10];
            BitRev10 rev10_inst (
                .in(segments_in[i]),
                .out(segments_out[i])
            );
        end
    endgenerate

    // Concatenate reversed segments in reverse order to form the output
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment_concat
            assign out[(i*10) +: 10] = segments_out[9 - i];
        end
    endgenerate

endmodule