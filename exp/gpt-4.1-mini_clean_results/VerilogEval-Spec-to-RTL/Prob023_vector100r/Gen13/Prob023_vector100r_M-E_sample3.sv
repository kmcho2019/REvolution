module BitRev10 (
    input  wire [9:0] in,
    output wire [9:0] out
);
    assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9]};
endmodule

module BitRev10_corrected (
    input  wire [9:0] in,
    output wire [9:0] out
);
    // Reverse 10-bit vector: out[i] = in[9-i]
    genvar i;
    generate
        for(i = 0; i < 10; i = i + 1) begin: rev_loop
            assign out[i] = in[9 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    wire [9:0] chunk_in [9:0];
    wire [9:0] chunk_out [9:0];

    genvar i;
    generate
        for(i = 0; i < 10; i = i + 1) begin : chunk_split
            assign chunk_in[i] = in[i*10 +: 10];
            BitRev10_corrected rev10 (
                .in(chunk_in[i]),
                .out(chunk_out[i])
            );
        end
    endgenerate

    // Concatenate reversed chunks in reverse order to form the final output
    assign out = {chunk_out[0], chunk_out[1], chunk_out[2], chunk_out[3], chunk_out[4],
                  chunk_out[5], chunk_out[6], chunk_out[7], chunk_out[8], chunk_out[9]};
endmodule