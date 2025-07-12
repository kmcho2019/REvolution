module BitRev10 (
    input  wire [9:0] in,
    output wire [9:0] out
);
    genvar i;
    generate
        for(i=0; i<10; i=i+1) begin : bit_reverse_loop
            assign out[i] = in[9 - i];
        end
    endgenerate
endmodule

module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out
);
    // Divide input into ten 10-bit chunks
    wire [9:0] chunk [0:9];
    wire [9:0] rev_chunk [0:9];

    genvar idx;
    generate
        for (idx = 0; idx < 10; idx = idx + 1) begin : chunk_assign
            assign chunk[idx] = in[ (idx+1)*10 -1 : idx*10 ];
            BitRev10 br10_inst (
                .in(chunk[idx]),
                .out(rev_chunk[idx])
            );
        end
    endgenerate

    // Concatenate reversed chunks in reverse order to produce fully reversed 100-bit output
    assign out = { rev_chunk[0], rev_chunk[1], rev_chunk[2], rev_chunk[3], rev_chunk[4],
                   rev_chunk[5], rev_chunk[6], rev_chunk[7], rev_chunk[8], rev_chunk[9] };

    // The above concatenation is the reversed order of reversed chunks,
    // so the whole 100-bit vector is reversed bitwise.

    // Explanation: Since each 10-bit chunk is individually reversed,
    // to get the full 100-bit reversed vector,
    // we place the last reversed chunk at the output's first 10 bits and so on.
    // Because concatenation is done with rev_chunk[0] at MSB side, 
    // and rev_chunk[9] at LSB side,
    // it reverses the order of chunks as well.
endmodule