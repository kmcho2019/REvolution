module BitRev10 (
    input  wire [9:0] in,
    output wire [9:0] out
);
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : bit_rev_loop
            assign out[i] = in[9 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Split input into 10 segments of 10 bits each
    wire [9:0] seg_in [0:9];
    wire [9:0] seg_out [0:9];

    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment_split
            assign seg_in[i] = in[i*10 +: 10];
        end
    endgenerate

    // Reverse bits within each 10-bit segment using generate-for loop
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment_reverse
            BitRev10 bitrev_inst (
                .in(seg_in[i]),
                .out(seg_out[i])
            );
        end
    endgenerate

    // Concatenate reversed segments in reverse order for final output
    generate
        for (i = 0; i < 10; i = i + 1) begin : output_assemble
            assign out[i*10 +: 10] = seg_out[9 - i];
        end
    endgenerate
endmodule