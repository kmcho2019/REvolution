module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);

    // Segment the inputs into 10-bit chunks
    wire [9:0] a_segments [9:0];
    wire [9:0] b_segments [9:0];
    wire [9:0] out_segments [9:0];
    
    // Create segments
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment
            assign a_segments[i] = a[i*10 +: 10];
            assign b_segments[i] = b[i*10 +: 10];
            
            // First-level mux for each segment
            assign out_segments[i] = sel ? b_segments[i] : a_segments[i];
        end
    endgenerate
    
    // Combine segments for final output
    assign out = {out_segments[9], out_segments[8], out_segments[7], out_segments[6],
                 out_segments[5], out_segments[4], out_segments[3], out_segments[2],
                 out_segments[1], out_segments[0]};

endmodule