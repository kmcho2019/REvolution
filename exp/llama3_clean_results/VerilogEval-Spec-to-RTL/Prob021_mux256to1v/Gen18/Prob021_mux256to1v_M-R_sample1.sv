module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Divide the select signal into two parts: high 4 bits and low 4 bits
wire [3:0] high_sel = sel[7:4];
wire [3:0] low_sel = sel[3:0];

// Calculate the index of the desired 4-bit output
assign out = in[(high_sel * 64) + (low_sel * 4) +: 4];

endmodule