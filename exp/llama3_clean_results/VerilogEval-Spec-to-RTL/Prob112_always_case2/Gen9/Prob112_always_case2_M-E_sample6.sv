module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

wire msb_high; // Flag to indicate if most significant bits have a '1'
assign msb_high = in[3] | in[2];

wire lsb_pos; // Position of the first '1' in the least significant bits
assign lsb_pos = in[1]? 1'b1 : (in[0]? 1'b0 : 1'b0);

wire msb_pos; // Position of the first '1' in the most significant bits
assign msb_pos = in[3]? 1'b1 : (in[2]? 1'b0 : 1'b0);

assign pos = (msb_high)? {1'b1, msb_pos} : 
             (in[1] | in[0])? {1'b0, lsb_pos} : 
             2'b00;

endmodule