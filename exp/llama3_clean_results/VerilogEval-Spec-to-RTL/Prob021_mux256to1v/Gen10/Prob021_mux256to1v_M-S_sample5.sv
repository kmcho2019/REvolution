module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    assign out = in[(64 * sel[7:4] + 4 * sel[3:0]) +: 4];

endmodule