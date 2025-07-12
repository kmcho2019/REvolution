module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Shifted vectors to represent neighbors:
    // For out_both: neighbor to the left (higher index), shifted left by 1 bit, LSB zero-padded
    wire [3:0] in_left = {in[2:0], 1'b0};

    // For out_any: neighbor to the right (lower index), shifted right by 1 bit, MSB zero-padded
    wire [3:0] in_right = {1'b0, in[3:1]};

    // For out_different: neighbor to the left with wrap-around, left rotate by 1 bit
    wire [3:0] in_left_wrap = {in[2:0], in[3]};

    // Compute outputs:
    // out_both[i] = in[i] & in[i+1], out_both[3] = 0 as no neighbor for highest index
    assign out_both = in & in_left;
    assign out_both[3] = 1'b0;  // explicitly zero the MSB

    // out_any[i] = in[i] | in[i-1], out_any[0] = 0 as no neighbor for lowest index
    assign out_any = in | in_right;
    assign out_any[0] = 1'b0;   // explicitly zero the LSB

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    assign out_different = in ^ in_left_wrap;

endmodule