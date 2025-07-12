module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Segment the 100-bit bus into 5 segments of 20 bits
    wire [19:0] segment_mux [0:4];
    
    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : SEGMENT_MUX
            // Each segment gets its own 20-bit mux
            assign segment_mux[i] = sel ? 
                                  b[(i*20)+19 : i*20] : 
                                  a[(i*20)+19 : i*20];
            
            // Combine all segments into final output
            assign out[(i*20)+19 : i*20] = segment_mux[i];
        end
    endgenerate

endmodule