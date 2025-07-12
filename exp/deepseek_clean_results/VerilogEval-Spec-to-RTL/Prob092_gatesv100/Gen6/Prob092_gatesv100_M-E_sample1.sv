module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Segment the input into 10 segments of 10 bits
    wire [9:0] seg [9:0];
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : SEGMENTS
            assign seg[i] = in[10*i+9 : 10*i];
        end
    endgenerate

    // Process each segment independently
    wire [9:0] seg_both [9:0];
    wire [9:0] seg_any [9:0];
    wire [9:0] seg_diff [9:0];
    
    generate
        for (i = 0; i < 10; i = i + 1) begin : PROCESSING
            // out_both processing (AND with left neighbor)
            assign seg_both[i][9] = (i == 9) ? 1'b0 : seg[i][9] & seg[i+1][0];
            assign seg_both[i][8:0] = seg[i][8:0] & seg[i][9:1];
            
            // out_any processing (OR with right neighbor)
            assign seg_any[i][0] = (i == 0) ? 1'b0 : seg[i][0] | seg[i-1][9];
            assign seg_any[i][9:1] = seg[i][9:1] | seg[i][8:0];
            
            // out_different processing (XOR with left neighbor, wrapped)
            assign seg_diff[i] = seg[i] ^ {seg[i][0], seg[i][9:1]};
        end
    endgenerate

    // Combine segment results
    generate
        for (i = 0; i < 10; i = i + 1) begin : COMBINE
            assign out_both[10*i+9 : 10*i] = seg_both[i];
            assign out_any[10*i+9 : 10*i] = seg_any[i];
            assign out_different[10*i+9 : 10*i] = seg_diff[i];
        end
    endgenerate

endmodule