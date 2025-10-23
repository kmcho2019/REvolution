module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);
    // Parameters for chunk size and number of chunks
    localparam CHUNK_SIZE = 10;
    localparam N_CHUNKS = 100 / CHUNK_SIZE; // 10 chunks
    
    wire [N_CHUNKS-1:0] chunk_and;
    wire [N_CHUNKS-1:0] chunk_or;
    wire [N_CHUNKS-1:0] chunk_xor;
    
    genvar i;
    generate
        for (i = 0; i < N_CHUNKS; i = i + 1) begin : chunk_reduction
            wire [CHUNK_SIZE-1:0] slice = in[i*CHUNK_SIZE +: CHUNK_SIZE];
            assign chunk_and[i] = &slice;  // reduction AND of each chunk
            assign chunk_or[i]  = |slice;  // reduction OR of each chunk
            assign chunk_xor[i] = ^slice;  // reduction XOR of each chunk
        end
    endgenerate

    // Final output reductions over the chunks
    assign out_and = &chunk_and;
    assign out_or  = |chunk_or;
    assign out_xor = ^chunk_xor;
endmodule