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
    wire [9:0] chunks_in [9:0];
    wire [9:0] chunks_rev [9:0];

    // Split input into 10 chunks of 10 bits
    genvar i;
    generate
        for(i = 0; i < 10; i = i + 1) begin : input_chunking
            assign chunks_in[i] = in[i*10 +: 10];
        end
    endgenerate

    // Instantiate BitRev10 to reverse bits within each 10-bit chunk
    generate
        for(i = 0; i < 10; i = i + 1) begin : chunk_reversal
            BitRev10 br10 (.in(chunks_in[i]), .out(chunks_rev[i]));
        end
    endgenerate

    // Reverse the order of the chunks for the final output
    generate
        for(i = 0; i < 10; i = i + 1) begin : output_assembly
            assign out[i*10 +: 10] = chunks_rev[9 - i];
        end
    endgenerate
endmodule