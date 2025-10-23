module TopModule (
    input  [7:0] in,
    output [2:0] pos
);

wire [3:0] low_half_pos;
wire [3:0] high_half_pos;
wire low_half_valid, high_half_valid;

// Check lower 4 bits
assign low_half_valid = |in[3:0];
assign low_half_pos = (in[0]) ? 4'd0 :
                      (in[1]) ? 4'd1 :
                      (in[2]) ? 4'd2 :
                      (in[3]) ? 4'd3 :
                               4'd0; // default if no bit set, won't be used

// Check upper 4 bits
assign high_half_valid = |in[7:4];
assign high_half_pos = (in[4]) ? 4'd4 :
                       (in[5]) ? 4'd5 :
                       (in[6]) ? 4'd6 :
                       (in[7]) ? 4'd7 :
                                4'd0; // default if no bit set, won't be used

assign pos = low_half_valid ? low_half_pos[2:0] :
             high_half_valid ? high_half_pos[2:0] :
             3'd0;

endmodule