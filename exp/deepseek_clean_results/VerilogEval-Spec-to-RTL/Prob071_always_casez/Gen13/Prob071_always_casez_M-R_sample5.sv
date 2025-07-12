module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire lower_nibble_active = |in[3:0];
wire upper_nibble_active = |in[7:4];

wire [1:0] lower_pair_pos = in[0] ? 2'd0 : 
                           in[1] ? 2'd1 : 
                           in[2] ? 2'd2 : 
                           2'd3;

wire [1:0] upper_pair_pos = in[4] ? 2'd0 : 
                           in[5] ? 2'd1 : 
                           in[6] ? 2'd2 : 
                           2'd3;

assign pos = lower_nibble_active ? {1'b0, lower_pair_pos} : 
             upper_nibble_active ? {1'b1, upper_pair_pos} : 
             3'd0;

endmodule