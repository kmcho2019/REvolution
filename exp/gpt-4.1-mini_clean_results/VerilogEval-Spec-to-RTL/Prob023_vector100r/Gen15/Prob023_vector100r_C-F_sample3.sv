module BitRev10 (
    input  wire [9:0] in,
    output wire [9:0] out
);
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : bit_reverse
            assign out[i] = in[9 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);

    // Split input into 10 chunks of 10 bits each
    wire [9:0] chunks_in [9:0];
    wire [9:0] chunks_out [9:0];

    genvar idx;
    generate
        for (idx = 0; idx < 10; idx = idx + 1) begin : chunk_process
            assign chunks_in[idx] = in[idx*10 +: 10];
            BitRev10 rev_inst (
                .in(chunks_in[idx]),
                .out(chunks_out[idx])
            );
        end
    endgenerate

    // Concatenate reversed chunks in reverse order to form the full reversed output
    generate
        for (idx = 0; idx < 10; idx = idx + 1) begin : output_assign
            assign out[(idx*10) +: 10] = chunks_out[9 - idx];
        end
    endgenerate

endmodule