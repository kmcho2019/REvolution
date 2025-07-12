module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);
    // Calculate bit offset within 'in' vector for 4-bit selection
    wire [9:0] bit_offset = sel * 4;

    // Select 4-bit slice from 'in' starting at bit_offset
    assign out = in[bit_offset +: 4];
endmodule