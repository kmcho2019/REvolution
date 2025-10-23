// Define the barrel_shifter module
module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);
    reg [7:0] shifted;
    always @(*) begin
        case (ctrl)
            3'b001: shifted = {in[6:0], 1'b0}; // Shift by 1 position
            3'b010: shifted = {in[5:0], 2'b00}; // Shift by 2 positions
            3'b011: shifted = {in[5:0], 2'b00, 1'b0}; // Shift by 3 positions
            3'b100: shifted = {in[3:0], 4'b0000}; // Shift by 4 positions
            3'b101: shifted = {in[2:0], 5'b00000}; // Shift by 5 positions
            3'b110: shifted = {in[1:0], 6'b000000}; // Shift by 6 positions
            3'b111: shifted = {in[0], 7'b0000000}; // Shift by 7 positions
            default: shifted = in; // No shift
        endcase
    end
    assign out = shifted;
endmodule