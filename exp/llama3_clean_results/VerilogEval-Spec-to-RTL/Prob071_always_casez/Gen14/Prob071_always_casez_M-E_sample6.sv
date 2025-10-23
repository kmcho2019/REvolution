module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

    wire mid_lo, mid_hi;
    assign mid_lo = in[3] || in[2] || in[1] || in[0];
    assign mid_hi = in[7] || in[6] || in[5] || in[4];

    wire quarter_lo, quarter_hi;
    assign quarter_lo = in[1] || in[0];
    assign quarter_hi = in[7] || in[6];

    wire eighth_lo, eighth_hi;
    assign eighth_lo = in[0];
    assign eighth_hi = in[7];

    assign pos = (mid_lo) ? 
                  ((in[3]) ? 3'd3 :
                   (in[2]) ? 3'd2 :
                   (in[1]) ? 3'd1 :
                   (in[0]) ? 3'd0 : 3'd0) :
                  ((in[7]) ? 3'd7 :
                   (in[6]) ? 3'd6 :
                   (in[5]) ? 3'd5 :
                   (in[4]) ? 3'd4 : 3'd0);

endmodule