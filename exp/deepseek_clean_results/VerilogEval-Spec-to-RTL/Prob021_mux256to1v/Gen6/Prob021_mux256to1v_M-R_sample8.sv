module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Use shift operations instead of multiplication
    // sel[7:4] << 6 = *64 (group selection)
    // sel[3:0] << 2 = *4 (word selection within group)
    assign out = in[((sel[7:4] << 6) + (sel[3:0] << 2) +: 4];

endmodule