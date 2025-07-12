module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i = 0..98 (neighbor to the left is in[i+1])
    // out_both[99] = 0 because in[99] has no left neighbor
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i = 1..99 (neighbor to the right is in[i-1])
    // out_any[0] = 0 because in[0] has no right neighbor
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i-1) mod 100]
    // wrap-around with neighbor to the left of in[0] being in[99]
    assign out_different = in ^ {in[0], in[99:1]};

endmodule