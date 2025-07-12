module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the absolute position of the desired 4-bit input
wire [9:0] offset;
assign offset = (sel * 4);

// Extract the corresponding 4-bit input using bitwise indexing
assign out = in[offset +: 4];

endmodule