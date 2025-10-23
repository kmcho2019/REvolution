module TopModule (
    input  [99:0] in,
    output [99:0] out
);

// Hierarchical bit reversal using segment reversal
// First reverse 20-bit segments, then reverse segment order

// Reverse each 20-bit segment
wire [19:0] seg0, seg1, seg2, seg3, seg4;
wire [19:0] seg0_rev, seg1_rev, seg2_rev, seg3_rev, seg4_rev;

assign seg0 = in[19:0];
assign seg1 = in[39:20];
assign seg2 = in[59:40];
assign seg3 = in[79:60];
assign seg4 = in[99:80];

genvar i;
generate
    // Reverse bits within each segment
    for (i = 0; i < 20; i = i + 1) begin : reverse_segments
        assign seg0_rev[i] = seg0[19 - i];
        assign seg1_rev[i] = seg1[19 - i];
        assign seg2_rev[i] = seg2[19 - i];
        assign seg3_rev[i] = seg3[19 - i];
        assign seg4_rev[i] = seg4[19 - i];
    end
    
    // Assign reversed segments in reverse order
    for (i = 0; i < 20; i = i + 1) begin : assign_output
        assign out[i]      = seg4_rev[i];
        assign out[20+i]   = seg3_rev[i];
        assign out[40+i]   = seg2_rev[i];
        assign out[60+i]   = seg1_rev[i];
        assign out[80+i]   = seg0_rev[i];
    end
endgenerate

endmodule