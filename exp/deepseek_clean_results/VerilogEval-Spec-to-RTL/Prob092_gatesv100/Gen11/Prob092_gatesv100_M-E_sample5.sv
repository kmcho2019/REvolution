module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Segment processing units
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : segment
            localparam start = i * 10;
            localparam end_bit = (i == 9) ? 99 : start + 9;
            
            // Segment processing
            wire [9:0] seg_in = in[end_bit:start];
            wire [9:0] seg_both, seg_any, seg_diff;
            
            // Internal bits (1-9)
            assign seg_both[9:1] = seg_in[8:0] & seg_in[9:1];
            assign seg_any[9:1] = seg_in[9:1] | seg_in[8:0];
            assign seg_diff[9:1] = seg_in[9:1] ^ seg_in[8:0];
            
            // Boundary bits
            assign seg_both[0] = (i == 0) ? 1'b0 : seg_in[0] & in[start-1];
            assign seg_any[0] = (i == 0) ? 1'b0 : seg_in[0] | in[start-1];
            assign seg_diff[0] = (i == 0) ? seg_in[0] ^ in[99] : seg_in[0] ^ in[start-1];
            
            // Connect outputs
            assign out_both[end_bit:start] = (i == 9) ? {1'b0, seg_both[8:0]} : seg_both;
            assign out_any[end_bit:start] = (i == 0) ? {seg_any[9:1], 1'b0} : seg_any;
            assign out_different[end_bit:start] = seg_diff;
        end
    endgenerate

endmodule