module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

wire [3:0] left_half = in[7:4];
wire [3:0] right_half = in[3:0];
wire left_has_bit = |left_half;
wire right_has_bit = |right_half;

// Level 1: Choose between upper and lower nibble
wire select_left = left_has_bit & ~right_has_bit;
wire [1:0] nibble_pos;

// Level 2: Encode position within selected nibble
assign nibble_pos = select_left ? 
                   (left_half[3] ? 2'b11 :
                    left_half[2] ? 2'b10 :
                    left_half[1] ? 2'b01 :
                    left_half[0] ? 2'b00 : 2'b00) :
                   (right_half[3] ? 2'b11 :
                    right_half[2] ? 2'b10 :
                    right_half[1] ? 2'b01 :
                    right_half[0] ? 2'b00 : 2'b00);

always @(*) begin
    if (|in) begin
        pos = {select_left, nibble_pos};
    end else begin
        pos = 3'b000;
    end
end

endmodule