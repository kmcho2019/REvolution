module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [1:0] lower_nibble = in[3:0] ? 2'b00 : 2'b10;
wire [1:0] upper_nibble = in[7:4] ? 2'b01 : 2'b11;

wire [1:0] nibble_sel = (lower_nibble[1] & upper_nibble[1]) ? 2'b00 : 
                       (lower_nibble[1] ? lower_nibble : upper_nibble);

wire [3:0] selected_nibble = nibble_sel[1] ? 
                            (nibble_sel[0] ? in[7:4] : in[3:0]) : 4'b0;

wire [1:0] bit_sel = selected_nibble[1:0] ? 2'b00 :
                    selected_nibble[3:2] ? 2'b01 : 2'b00;

wire bit_pos = bit_sel[1] ? 1'b0 :
              (selected_nibble[{bit_sel,1'b1}] ? 1'b1 : 1'b0);

assign pos = {nibble_sel[0], bit_sel[0], bit_pos};

endmodule