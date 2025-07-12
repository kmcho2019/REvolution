module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i]: in[i] & in[i+1] for i=0..98; out_both[99] = 0
    // Pad in with zero at MSB side to shift left safely
    wire [100:0] in_padded_left = {1'b0, in};
    assign out_both = in & in_padded_left[99:0];

    // out_any[i]: in[i] | in[i-1] for i=1..99; out_any[0] = 0
    // Pad in with zero at LSB side to shift right safely
    wire [100:0] in_padded_right = {in, 1'b0};
    assign out_any = in | in_padded_right[100:1];
    assign out_any[0] = 1'b0; // explicitly zero as specified

    // out_different[i]: in[i] ^ neighbor to left with wrap-around
    // neighbor to left: in[(i+1)%100] = {in[0], in[99:1]}
    wire [99:0] in_rotated_left = {in[0], in[99:1]};
    assign out_different = in ^ in_rotated_left;

endmodule