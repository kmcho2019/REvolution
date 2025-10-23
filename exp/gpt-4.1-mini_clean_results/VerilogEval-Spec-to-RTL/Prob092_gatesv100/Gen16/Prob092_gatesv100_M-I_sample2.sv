module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99]=0
    assign out_both[98:0] = in[98:0] & in[99:1];
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0]=0
    assign out_any[99:1] = in[99:1] | in[98:0];
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) % 100] with wrap-around neighbor on left
    // Note: The neighbor to the left of i is (i+1)%100 (wrap-around)
    // We can form shifted vector by concatenating in[98:0] and in[99] at LSB position:
    // But since wrap-around is from i to i+1 mod 100, use concatenation to get neighbor vector
    wire [99:0] in_wrapped_neighbor = {in[98:0], in[99]};
    assign out_different = in ^ in_wrapped_neighbor;

endmodule