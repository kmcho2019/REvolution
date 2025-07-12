module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [1:0] lower_pos;
wire [1:0] upper_pos;
wire lower_active;
wire upper_active;

// 4-bit priority encoder for lower nibble
assign lower_pos = in[0] ? 2'd0 :
                   in[1] ? 2'd1 :
                   in[2] ? 2'd2 :
                   in[3] ? 2'd3 :
                           2'd0;

assign lower_active = |in[3:0];

// 4-bit priority encoder for upper nibble
assign upper_pos = in[4] ? 2'd0 :
                   in[5] ? 2'd1 :
                   in[6] ? 2'd2 :
                   in[7] ? 2'd3 :
                           2'd0;

assign upper_active = |in[7:4];

// Combine results with priority to lower nibble
assign pos = lower_active ? {1'b0, lower_pos} :
             upper_active ? {1'b1, upper_pos} :
                            3'd0;

endmodule