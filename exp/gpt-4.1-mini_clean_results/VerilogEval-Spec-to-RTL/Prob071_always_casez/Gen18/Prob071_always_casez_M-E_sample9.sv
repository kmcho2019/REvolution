module TopModule (
    input  [7:0] in,
    output [2:0] pos
);
    wire [2:0] pos_low, pos_high;

    // Priority encoder for lower nibble (bits 3:0)
    assign pos_low = (in[0]) ? 3'd0 :
                     (in[1]) ? 3'd1 :
                     (in[2]) ? 3'd2 :
                     (in[3]) ? 3'd3 : 3'd0;

    // Priority encoder for upper nibble (bits 7:4)
    assign pos_high = (in[4]) ? 3'd4 :
                      (in[5]) ? 3'd5 :
                      (in[6]) ? 3'd6 :
                      (in[7]) ? 3'd7 : 3'd0;

    // If any bit in lower nibble is set, select pos_low; else if any bit in upper nibble is set, select pos_high; else zero
    assign pos = (|in[3:0]) ? pos_low :
                 (|in[7:4]) ? pos_high : 3'd0;

endmodule