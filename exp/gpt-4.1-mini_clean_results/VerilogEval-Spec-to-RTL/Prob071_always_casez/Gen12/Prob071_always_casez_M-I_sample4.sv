module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

// Encode lower 4 bits
wire [1:0] low_pos;
wire low_valid;
assign low_valid = |in[3:0];
assign low_pos = in[0] ? 2'd0 :
                 in[1] ? 2'd1 :
                 in[2] ? 2'd2 :
                 in[3] ? 2'd3 :
                 2'd0;  // default, won't be used if low_valid=0

// Encode upper 4 bits
wire [1:0] high_pos;
wire high_valid;
assign high_valid = |in[7:4];
assign high_pos = in[4] ? 2'd0 :
                  in[5] ? 2'd1 :
                  in[6] ? 2'd2 :
                  in[7] ? 2'd3 :
                  2'd0; // default, won't be used if high_valid=0

// Combine results
assign pos = low_valid ? {1'b0, low_pos} :          // MSB=0: lower half
                      high_valid ? {1'b1, high_pos} :  // MSB=1: upper half
                      3'd0;                          // no bits set

endmodule