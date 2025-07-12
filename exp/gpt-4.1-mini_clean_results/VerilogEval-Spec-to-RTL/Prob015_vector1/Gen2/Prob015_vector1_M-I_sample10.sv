module TopModule (
    input  [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo
);
    localparam integer HIGH_START = 15;
    localparam integer HIGH_END   = 8;
    localparam integer LOW_START  = 7;
    localparam integer LOW_END    = 0;

    assign out_hi = in[HIGH_START:HIGH_END];
    assign out_lo = in[LOW_START:LOW_END];
endmodule