module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

    wire [1:0] low_pos;
    wire low_any;
    wire [1:0] high_pos;
    wire high_any;

    // Priority encoder for lower 4 bits
    assign low_any = |in[3:0];
    assign low_pos = (in[0]) ? 2'd0 :
                     (in[1]) ? 2'd1 :
                     (in[2]) ? 2'd2 :
                     (in[3]) ? 2'd3 : 2'd0;

    // Priority encoder for upper 4 bits
    assign high_any = |in[7:4];
    assign high_pos = (in[4]) ? 2'd0 :
                      (in[5]) ? 2'd1 :
                      (in[6]) ? 2'd2 :
                      (in[7]) ? 2'd3 : 2'd0;

    // Combine results: if lower nibble has set bits, output low_pos; else output high_pos + 4; else zero
    assign pos = low_any ? {1'b0, low_pos} :
                 high_any ? {1'b1, high_pos} :
                 3'd0;

endmodule