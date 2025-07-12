module TopModule (
    input  wire [1023:0] in,   // 256 inputs * 4 bits = 1024 bits
    input  wire [7:0]    sel,  // 8-bit select
    output wire [3:0]    out   // 4-bit output
);

    // Direct indexed part-select from input vector.
    // sel ranges 0 to 255, each selects 4 bits from 'in'.
    assign out = in[sel*4 +: 4];

endmodule