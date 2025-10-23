module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Create mask once and reuse for all chunks
    wire [99:0] mask = {100{sel}};
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : mux_chunk
            // Process 25-bit chunks using bitwise operations
            assign out[i*25 +: 25] = (a[i*25 +: 25] & ~mask[i*25 +: 25]) | 
                                   (b[i*25 +: 25] & mask[i*25 +: 25]);
        end
    endgenerate

endmodule