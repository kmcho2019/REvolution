module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99]=0
    assign out_both = { (in[98:0] & in[99:1]), 1'b0 };

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0]=0
    assign out_any = { 1'b0, (in[99:1] | in[98:0]) };

    // out_different[i] = in[i] ^ in[(i+1) mod 100]
    // Create a rotated version of in by one bit left to represent neighbors to the left with wrap-around
    wire [99:0] in_rot;
    assign in_rot = { in[98:0], in[99] };

    assign out_different = in ^ in_rot;

endmodule