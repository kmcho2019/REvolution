module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    localparam SPLIT_POINT = 8;
    
    assign {out_hi, out_lo} = in;
    // Alternative implementation showing the flexibility:
    // assign out_hi = in[15:SPLIT_POINT];
    // assign out_lo = in[SPLIT_POINT-1:0];

endmodule