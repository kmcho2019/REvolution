module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);
    // Calculate starting bit index based on sel
    // Each chunk is 4 bits, so index = sel * 4
    // Select bits from in[index+3:index]
    wire [10:0] start_bit = sel << 2;  // sel * 4

    assign out = in[start_bit +: 4];
endmodule