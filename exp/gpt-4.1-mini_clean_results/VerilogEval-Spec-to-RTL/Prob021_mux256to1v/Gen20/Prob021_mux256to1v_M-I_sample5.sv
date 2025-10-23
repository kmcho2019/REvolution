module TopModule (
    input  wire [1023:0] in,  // 256 inputs * 4 bits each = 1024 bits total
    input  wire [7:0]    sel, // Select signal [0..255]
    output wire [3:0]    out
);

    // Directly select the 4-bit slice from 'in' indexed by 'sel'
    // Each 4-bit word is at bits [sel*4 + 3 : sel*4]
    assign out = in[sel*4 +: 4];

endmodule