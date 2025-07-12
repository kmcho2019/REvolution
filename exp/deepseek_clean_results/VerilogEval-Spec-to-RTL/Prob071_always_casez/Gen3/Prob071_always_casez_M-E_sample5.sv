module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire lower_half_set = |in[3:0];
wire [1:0] lower_pos = in[1:0] != 2'b00 ? (in[0] ? 2'b00 : 2'b01) :
                       (in[2] ? 2'b10 : 2'b11);
wire [1:0] upper_pos = in[5:4] != 2'b00 ? (in[4] ? 2'b00 : 2'b01) :
                       (in[6] ? 2'b10 : 2'b11);

assign pos = lower_half_set ? {1'b0, lower_pos} : 
             (|in[7:4] ? {1'b1, upper_pos} : 3'b000);

endmodule