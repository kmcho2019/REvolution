module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Calculate the bit offset based on sel:
    // Each 4-bit input is sel*4 bits offset
    wire [9:0] bit_offset = sel * 4;

    // Assign output bits directly from the input vector
    assign out = in[bit_offset +: 4];

endmodule