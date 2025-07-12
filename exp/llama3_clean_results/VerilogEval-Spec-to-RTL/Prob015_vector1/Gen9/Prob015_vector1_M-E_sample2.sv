module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Define constants for upper and lower byte masks
    localparam UPPER_BYTE_MASK = 16'hFF00;
    localparam LOWER_BYTE_MASK = 16'h00FF;

    // Use bitwise AND operations to extract upper and lower bytes
    assign out_hi = (in & UPPER_BYTE_MASK) >> 8;
    assign out_lo = in & LOWER_BYTE_MASK;

endmodule