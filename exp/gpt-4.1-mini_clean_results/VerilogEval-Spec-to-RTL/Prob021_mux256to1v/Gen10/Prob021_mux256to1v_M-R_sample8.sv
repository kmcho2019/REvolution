module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate bit offset based on sel
    wire [9:0] bit_offset = sel * 4;
    // Assign 4-bit output slice from input vector
    assign out = in[bit_offset +: 4];
endmodule