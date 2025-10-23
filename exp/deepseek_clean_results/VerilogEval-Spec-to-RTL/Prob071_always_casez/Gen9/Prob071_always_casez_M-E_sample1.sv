module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire lower_nibble_has_one = |in[3:0];
wire [1:0] lower_pos = in[0] ? 2'b00 :
                      in[1] ? 2'b01 :
                      in[2] ? 2'b10 :
                      in[3] ? 2'b11 : 2'b00;
                      
wire [1:0] upper_pos = in[4] ? 2'b00 :
                      in[5] ? 2'b01 :
                      in[6] ? 2'b10 :
                      in[7] ? 2'b11 : 2'b00;

assign pos = (|in) ? {~lower_nibble_has_one, 
                     lower_nibble_has_one ? lower_pos : upper_pos} : 3'b000;

endmodule