module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // For out_both: out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0
    // Implement by shifting in left by 1 bit and AND with in[98:0] concatenated with 0 at MSB
    assign out_both = (in & {in[98:0], 1'b0});

    // For out_any: out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0
    // Shift in right by 1 bit, OR with in[99:1], and set LSB=0
    assign out_any = (in | {1'b0, in[99:1]}) & {99'h7FFFFFFFFFFFFFFFFFFFF, 1'b0}; 
    // The mask clears bit 0 explicitly. 99'h7FFFFFFFFFFFFFFFFFFFF is 99 ones for upper bits.

    // For out_different: bitwise XOR of in and a left rotated version of in by 1 bit (wrap-around)
    assign out_different = in ^ {in[98:0], in[99]};

endmodule