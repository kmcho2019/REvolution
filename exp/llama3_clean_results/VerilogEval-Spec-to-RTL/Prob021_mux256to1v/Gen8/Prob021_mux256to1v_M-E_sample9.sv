module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [1023:0] coarse_shifted;
    wire [1023:0] fine_shifted;

    // Coarse shift to align the 64-bit group
    assign coarse_shifted = in >> (sel[7:4] * 64);

    // Fine shift to align the 4-bit group within the 64-bit group
    assign fine_shifted = coarse_shifted >> (sel[3:0] * 4);

    // Mask to extract the desired 4-bit output
    assign out = fine_shifted[3:0];

endmodule