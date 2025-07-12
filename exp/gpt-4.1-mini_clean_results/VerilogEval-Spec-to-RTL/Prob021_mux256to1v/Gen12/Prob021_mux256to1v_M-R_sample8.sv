module TopModule (
    input  wire [1023:0] in,   // 256 inputs x 4 bits = 1024 bits
    input  wire [7:0]    sel,  // selects which 4-bit input to output
    output wire [3:0]    out
);
    // Directly slice out 4 bits from 'in' based on sel index
    assign out = in[sel*4 +: 4];
endmodule