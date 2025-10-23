module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    localparam HIGH_IDX = 15;
    localparam LOW_IDX = 8;
    localparam MID_IDX = 7;
    localparam ZERO_IDX = 0;

    assign out_hi = in[HIGH_IDX:LOW_IDX];
    assign out_lo = in[MID_IDX:ZERO_IDX];

endmodule