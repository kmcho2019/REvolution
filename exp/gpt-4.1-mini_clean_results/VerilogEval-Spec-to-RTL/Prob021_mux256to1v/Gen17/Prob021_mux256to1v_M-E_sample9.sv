module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Compute the starting bit index from sel by multiplying by 4 (shift left by 2)
    wire [10:0] start_bit = sel << 2; // 8-bit sel * 4 = max 1020, fits in 11 bits

    // Directly assign the output by slicing 'in' at the computed start bit position
    assign out = in[start_bit +: 4];

endmodule