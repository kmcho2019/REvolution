module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // out_both[i] = in[i] & in[i+1], for i=0..2; out_both[3]=0 since no neighbor to the left
    assign out_both[2:0] = in[2:0] & in[3:1];
    assign out_both[3] = 1'b0;

    // out_any[i] = in[i] | in[i-1], for i=1..3; out_any[0]=0 since no neighbor to the right
    assign out_any[3:1] = in[3:1] | in[2:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) mod 4], wrap around by rotating in left by 1
    wire [3:0] in_rot;
    assign in_rot = {in[2:0], in[3]};  // left rotate by 1: bit 3 goes to bit 0

    assign out_different = in ^ in_rot;

endmodule