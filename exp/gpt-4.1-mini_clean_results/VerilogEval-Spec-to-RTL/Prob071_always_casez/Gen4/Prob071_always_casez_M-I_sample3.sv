module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

// Mask to isolate the least significant set bit
wire [7:0] lsb_mask = in & (~in + 1'b1);

// Binary encoding of the one-hot lsb_mask
assign pos = (lsb_mask[0]) ? 3'd0 :
             (lsb_mask[1]) ? 3'd1 :
             (lsb_mask[2]) ? 3'd2 :
             (lsb_mask[3]) ? 3'd3 :
             (lsb_mask[4]) ? 3'd4 :
             (lsb_mask[5]) ? 3'd5 :
             (lsb_mask[6]) ? 3'd6 :
             (lsb_mask[7]) ? 3'd7 :
                            3'd0;

endmodule