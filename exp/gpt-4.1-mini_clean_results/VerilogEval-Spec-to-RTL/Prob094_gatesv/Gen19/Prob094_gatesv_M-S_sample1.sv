module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // For out_both[i], check in[i] & in[i+1] for i=0..2, out_both[3]=0 (no neighbor)
    // Shift in left by 1, zero pad at LSB for out_both[3]
    assign out_both = (in & {in[2:0], 1'b0});

    // For out_any[i], check in[i] | in[i-1] for i=1..3, out_any[0]=0 (no neighbor)
    // Shift in right by 1, zero pad at MSB for out_any[0]
    assign out_any = (in | {1'b0, in[3:1]});

    // For out_different[i], in[i] xor in[(i+1) mod 4], wrap-around with rotate left by 1
    assign out_different = in ^ {in[0], in[3:1]};

endmodule