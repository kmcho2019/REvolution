module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[2:0] = in[2:0] & in[3:1], out_both[3] = 0
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3]   = 1'b0;

    // out_any[3:1] = in[3:1] | in[2:0], out_any[0] = 0
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0]   = 1'b0;

    // out_different = in ^ rotated left version of in by 1 bit (wrap-around)
    wire [3:0] in_rot_left1 = {in[2:0], in[3]};
    assign out_different = in ^ in_rot_left1;

endmodule