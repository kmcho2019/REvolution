module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i]: in[i] & in[i+1] for i=0..98; out_both[99]=0
    // Use vector slice: in[98:0] & in[99:1], then pad with 0 at MSB
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i]: in[i] | in[i-1] for i=1..99; out_any[0]=0
    // Use vector slice: in[99:1] | in[98:0], then pad with 0 at LSB
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i]: in[i] xor neighbor to left (with wrap-around)
    // neighbor to left of in[99] is in[0], so wrap around by concatenating
    // shifted vector with wrap-around
    wire [99:0] in_left_neighbor = {in[0], in[99:1]};
    assign out_different = in ^ in_left_neighbor;

endmodule