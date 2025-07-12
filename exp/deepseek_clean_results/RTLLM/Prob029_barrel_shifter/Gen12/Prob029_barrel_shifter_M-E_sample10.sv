module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    always @(*) begin
        case (ctrl)
            3'b000: out = in;                          // No shift
            3'b001: out = {in[0], in[7:1]};            // Shift right by 1
            3'b010: out = {in[1:0], in[7:2]};          // Shift right by 2
            3'b011: out = {in[2:0], in[7:3]};          // Shift right by 3
            3'b100: out = {in[3:0], in[7:4]};          // Shift right by 4
            3'b101: out = {in[4:0], in[7:5]};          // Shift right by 5
            3'b110: out = {in[5:0], in[7:6]};          // Shift right by 6
            3'b111: out = {in[6:0], in[7]};            // Shift right by 7
        endcase
    end
endmodule