module SegmentModule (
    input [9:0] in_seg,
    input left_bit,  // For cross-segment connection
    output [9:0] seg_both,
    output [9:0] seg_any,
    output [9:0] seg_diff
);
    // out_both: AND with left neighbor (bit 9 = 0)
    assign seg_both = {1'b0, in_seg[8:0] & in_seg[9:1]};
    
    // out_any: OR with right neighbor (bit 0 = 0)
    assign seg_any = {in_seg[9:1] | in_seg[8:0], 1'b0};
    
    // out_different: XOR with left neighbor (wrapped within segment)
    // Except for bit 0 which needs left_bit from previous segment
    assign seg_diff = in_seg ^ {left_bit, in_seg[9:1]};
endmodule

module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);
    // Instantiate 10 segment modules
    wire [9:0] seg_both [9:0];
    wire [9:0] seg_any [9:0];
    wire [9:0] seg_diff [9:0];
    
    // Generate segments with proper connections
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : SEGMENTS
            wire left_bit_for_segment;
            
            // Determine left_bit for segment (wrapped around)
            assign left_bit_for_segment = (i == 0) ? in[9] : in[i*10-1];
            
            SegmentModule seg (
                .in_seg(in[i*10 +: 10]),
                .left_bit(left_bit_for_segment),
                .seg_both(seg_both[i]),
                .seg_any(seg_any[i]),
                .seg_diff(seg_diff[i])
            );
        end
    endgenerate
    
    // Combine all segment outputs
    assign out_both = {seg_both[9], seg_both[8], seg_both[7], seg_both[6], seg_both[5],
                      seg_both[4], seg_both[3], seg_both[2], seg_both[1], seg_both[0]};
                      
    assign out_any = {seg_any[9], seg_any[8], seg_any[7], seg_any[6], seg_any[5],
                     seg_any[4], seg_any[3], seg_any[2], seg_any[1], seg_any[0]};
                     
    assign out_different = {seg_diff[9], seg_diff[8], seg_diff[7], seg_diff[6], seg_diff[5],
                          seg_diff[4], seg_diff[3], seg_diff[2], seg_diff[1], seg_diff[0]};
endmodule