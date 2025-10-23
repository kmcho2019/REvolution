module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    always @(*) begin
        // Calculate total shift amount (0-7)
        case (ctrl)
            3'b000: out = in;
            3'b001: out = {in[0], in[7:1]};       // Shift right by 1
            3'b010: out = {in[1:0], in[7:2]};     // Shift right by 2
            3'b011: out = {in[2:0], in[7:3]};     // Shift right by 3 (1+2)
            3'b100: out = {in[3:0], in[7:4]};     // Shift right by 4
            3'b101: out = {in[4:0], in[7:5]};     // Shift right by 5 (4+1)
            3'b110: out = {in[5:0], in[7:6]};     // Shift right by 6 (4+2)
            3'b111: out = {in[6:0], in[7]};       // Shift right by 7 (4+2+1)
        endcase
    end
endmodule