module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [1:0] sel_nibble = |in[3:0] ? 2'b00 : 2'b01;
wire [3:0] selected_nibble = sel_nibble[1] ? in[7:4] : in[3:0];
wire [1:0] sel_pair = |selected_nibble[1:0] ? 2'b00 : 2'b01;
wire [1:0] selected_pair = sel_pair[1] ? selected_nibble[3:2] : selected_nibble[1:0];
wire sel_bit = selected_pair[0] ? 1'b0 : 1'b1;

assign pos = {sel_nibble[1], sel_pair[1], sel_bit} + 
             (sel_nibble[1] ? 3'b100 : 3'b000);

endmodule