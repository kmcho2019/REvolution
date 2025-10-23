module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);

// Generate all possible rotated versions
wire [7:0] rotated [0:7];
assign rotated[0] = in;  // no rotation
assign rotated[1] = {in[0], in[7:1]};  // rotate right by 1
assign rotated[2] = {in[1:0], in[7:2]};  // rotate right by 2
assign rotated[3] = {in[2:0], in[7:3]};  // rotate right by 3
assign rotated[4] = {in[3:0], in[7:4]};  // rotate right by 4
assign rotated[5] = {in[4:0], in[7:5]};  // rotate right by 5
assign rotated[6] = {in[5:0], in[7:6]};  // rotate right by 6
assign rotated[7] = {in[6:0], in[7]};    // rotate right by 7

// Select the appropriate rotation based on control bits
always @(*) begin
    case (ctrl)
        3'b000: out = rotated[0];
        3'b001: out = rotated[1];
        3'b010: out = rotated[2];
        3'b011: out = rotated[3];
        3'b100: out = rotated[4];
        3'b101: out = rotated[5];
        3'b110: out = rotated[6];
        3'b111: out = rotated[7];
    endcase
end

endmodule