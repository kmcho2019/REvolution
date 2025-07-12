module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Segment processing (10 segments of 10 bits each)
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin: segment
            // Regular bits within segment
            if (i < 9) begin
                // out_both: current & left neighbor (except first bit)
                assign out_both[i*10 +: 10] = {1'b0, in[i*10+8:0] & in[i*10+9:1]};
                
                // out_any: current | right neighbor (except last bit)
                assign out_any[i*10 +: 10] = {in[i*10+9:1] | in[i*10+8:0], 1'b0};
                
                // out_different: current ^ left neighbor (with wrap-around at segment boundary)
                wire [9:0] segment_in = in[i*10 +: 10];
                wire [9:0] left_segment_in = (i == 0) ? {in[0], in[99:91]} : in[(i-1)*10 +: 10];
                wire [9:0] shifted_in = {segment_in[8:0], left_segment_in[9]};
                assign out_different[i*10 +: 10] = segment_in ^ shifted_in;
            end
            else begin // Last segment special handling
                // out_both
                assign out_both[90 +: 10] = {1'b0, in[98:90] & in[99:91]};
                
                // out_any
                assign out_any[90 +: 10] = {in[99:91] | in[98:90], 1'b0};
                
                // out_different with wrap-around to segment 0
                wire [9:0] segment_in = in[90 +: 10];
                wire [9:0] shifted_in = {segment_in[8:0], in[0]};
                assign out_different[90 +: 10] = segment_in ^ shifted_in;
            end
        end
    endgenerate

endmodule