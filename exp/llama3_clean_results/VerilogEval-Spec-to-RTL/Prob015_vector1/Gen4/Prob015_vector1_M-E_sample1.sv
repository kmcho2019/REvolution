module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Define masks for the high and low bytes
    wire [15:0] high_byte_mask = 16'b1111111100000000;
    wire [15:0] low_byte_mask  = 16'b0000000011111111;

    // Use bitwise AND to extract the high and low bytes
    wire [15:0] high_byte = (in & high_byte_mask) >> 8;
    wire [15:0] low_byte  = in & low_byte_mask;

    // Assign the extracted bytes to the outputs
    assign out_hi = high_byte[7:0];
    assign out_lo = low_byte[7:0];

endmodule