module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Divide the select signal into two parts: high 4 bits and low 4 bits
wire [3:0] high_sel = sel[7:4];
wire [3:0] low_sel = sel[3:0];

// Create a tree structure to select the desired 64-bit group
wire [63:0] group_out;
assign group_out = in[(high_sel * 64) +: 64];

// Create a tree structure to select the desired 4-bit output
assign out = group_out[(low_sel * 4) +: 4];

endmodule