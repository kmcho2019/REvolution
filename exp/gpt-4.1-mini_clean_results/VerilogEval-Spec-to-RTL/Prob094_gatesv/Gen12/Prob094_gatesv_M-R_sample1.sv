module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Shift 'in' left by one bit for neighbor to left comparison
    wire [3:0] in_left = {in[2:0], 1'b0};
    // Shift 'in' right by one bit for neighbor to right comparison
    wire [3:0] in_right = {1'b0, in[3:1]};
    // Rotate 'in' left by one bit for wrap-around neighbor to left
    wire [3:0] in_rot_left = {in[2:0], in[3]};

    // out_both[i] = in[i] & neighbor to left = in[i] & in[i+1], except highest bit (no neighbor)
    assign out_both = in & in_left;

    // out_any[i] = in[i] | neighbor to right = in[i] | in[i-1], except lowest bit (no neighbor)
    assign out_any = in | in_right;

    // out_different[i] = in[i] ^ neighbor to left (wrap around)
    assign out_different = in ^ in_rot_left;

endmodule