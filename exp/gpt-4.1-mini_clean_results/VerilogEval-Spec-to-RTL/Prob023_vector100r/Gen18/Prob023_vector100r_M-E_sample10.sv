module BitRev10 (
    input  wire [9:0] in,
    output wire [9:0] out
);
    // Reverse bits within a 10-bit vector
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : bitrev
            assign out[i] = in[9 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Split input into 10 chunks of 10 bits
    wire [9:0] chunks_in  [9:0];
    wire [9:0] chunks_out [9:0];

    genvar j;
    generate
        for (j = 0; j < 10; j = j + 1) begin : chunk_split_rev
            assign chunks_in[j] = in[(j+1)*10-1 -: 10];
            BitRev10 rev_inst (
                .in(chunks_in[j]),
                .out(chunks_out[j])
            );
        end
    endgenerate

    // Concatenate reversed chunks in reverse order
    generate
        for (j = 0; j < 10; j = j + 1) begin : concat_rev
            assign out[(j+1)*10-1 -: 10] = chunks_out[9 - j];
        end
    endgenerate
endmodule