module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    localparam UPPER_BYTE_END = 15;
    localparam UPPER_BYTE_START = 8;
    localparam LOWER_BYTE_END = 7;
    localparam LOWER_BYTE_START = 0;

    assign out_hi = in[UPPER_BYTE_END:UPPER_BYTE_START];
    assign out_lo = in[LOWER_BYTE_END:LOWER_BYTE_START];

endmodule