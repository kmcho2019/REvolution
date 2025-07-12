module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Shift input left by 1, LSB padded with 0 (neighbor to the left)
    wire [3:0] in_left_neighbor = {in[2:0], 1'b0};
    // out_both: bitwise AND of in and its left neighbor, clear MSB (no neighbor)
    assign out_both = (in & in_left_neighbor) & 4'b0111;

    // Shift input right by 1, MSB padded with 0 (neighbor to the right)
    wire [3:0] in_right_neighbor = {1'b0, in[3:1]};
    // out_any: bitwise OR of in and its right neighbor, clear LSB (no neighbor)
    assign out_any = (in | in_right_neighbor) & 4'b1110;

    // Circular right shift by 1 bit for wrap-around left neighbor
    wire [3:0] in_left_circular = {in[0], in[3:1]};
    // out_different: XOR of in and its left neighbor with wrap-around
    assign out_different = in ^ in_left_circular;

endmodule