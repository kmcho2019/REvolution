module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: bits 0 to 2 check in[i] & in[i+1], bit 3 = 0
    // Using vector slicing: in[2:0] & in[3:1]
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;

    // out_any: bits 1 to 3 check in[i] | in[i-1], bit 0 = 0
    // Using vector slicing: in[3:1] | in[2:0]
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;

    // out_different: in[i] ^ in[(i+1)%4], wrap-around circular shift by 1
    wire [3:0] in_rot_left;
    assign in_rot_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rot_left;

endmodule