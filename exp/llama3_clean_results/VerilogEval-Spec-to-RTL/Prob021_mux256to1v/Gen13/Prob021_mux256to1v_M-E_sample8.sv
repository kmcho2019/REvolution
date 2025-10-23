module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the index of the desired 4-bit group
wire [9:0] idx = sel * 4;

// Use bitwise operations to select the correct 4-bit value
assign out = in[(idx + 3) : idx];

endmodule