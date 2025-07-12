module BitRev10 (
    input  [9:0] in,
    output [9:0] out
);
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : bit_rev_10
            assign out[i] = in[9 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  [99:0] in,
    output [99:0] out
);
    // Wires to hold the reversed 10-bit chunks of input
    wire [9:0] rev_chunks [0:9];

    genvar idx;
    generate
        // For each 10-bit chunk: reverse bits within the chunk
        for (idx = 0; idx < 10; idx = idx + 1) begin : chunk_rev
            BitRev10 br10 (
                .in(in[(idx*10)+9 -: 10]),
                .out(rev_chunks[idx])
            );
        end
    endgenerate

    // Now assign to output by reversing the order of these reversed chunks
    // i.e. out[99:90] = rev_chunks[0], out[89:80] = rev_chunks[1], ..., out[9:0] = rev_chunks[9]
    generate
        for (idx = 0; idx < 10; idx = idx + 1) begin : out_assign
            assign out[(idx*10)+9 -: 10] = rev_chunks[9 - idx];
        end
    endgenerate
endmodule