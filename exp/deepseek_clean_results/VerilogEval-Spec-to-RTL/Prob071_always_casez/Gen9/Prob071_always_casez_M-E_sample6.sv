module TopModule (
    input [7:0] in,
    output reg [2:0] pos
);

wire [1:0] lower_half = in[3:0] ? 2'b00 : 2'b01;
wire [1:0] upper_half = in[7:4] ? 2'b10 : 2'b11;

wire [1:0] half_sel = (in[3:0] != 4'b0) ? lower_half : upper_half;

wire [1:0] quarter_pos;
assign quarter_pos = (half_sel[1]) ? 
                    (in[7:6] ? (in[7] ? 2'b11 : 2'b10) : (in[5] ? 2'b01 : 2'b00)) :
                    (in[3:2] ? (in[3] ? 2'b11 : 2'b10) : (in[1] ? 2'b01 : 2'b00));

always @(*) begin
    case ({half_sel[1], quarter_pos})
        3'b0_00: pos = 3'd0;
        3'b0_01: pos = 3'd1;
        3'b0_10: pos = 3'd2;
        3'b0_11: pos = 3'd3;
        3'b1_00: pos = 3'd4;
        3'b1_01: pos = 3'd5;
        3'b1_10: pos = 3'd6;
        3'b1_11: pos = 3'd7;
        default: pos = 3'd0;
    endcase
end

endmodule