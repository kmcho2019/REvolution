module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i]: both in[i] and its left neighbor in[i+1] are '1'
    // For i=0..98: out_both[i] = in[i] & in[i+1]
    // For i=99: no left neighbor, set 0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99]    = 1'b0;

    // out_any[i]: either in[i] or its right neighbor in[i-1] are '1'
    // For i=1..99: out_any[i] = in[i] | in[i-1]
    // For i=0: no right neighbor, set 0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0]    = 1'b0;

    // out_different[i]: in[i] differs from its left neighbor in[(i+1)%100]
    // Implement wrap-around by rotating vector left by 1 using vector concatenation
    wire [99:0] in_rot_left = {in[98:0], in[99]};
    assign out_different = in ^ in_rot_left;

endmodule