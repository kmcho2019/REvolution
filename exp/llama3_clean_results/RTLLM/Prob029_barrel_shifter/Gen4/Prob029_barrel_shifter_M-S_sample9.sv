module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Directly generate the shifted output based on the control signal
    always @(*) begin
        case (ctrl)
            3'b001: out = {in[6:0], in[7]}; // shift by 1 position
            3'b010: out = {in[5:0], in[7:6]}; // shift by 2 positions
            3'b011: out = {in[5:0], in[7:6], in[7]}; // shift by 3 positions
            3'b100: out = {in[4:0], in[7:5]}; // shift by 4 positions
            3'b101: out = {in[4:0], in[7:5], in[7]}; // shift by 5 positions
            3'b110: out = {in[4:0], in[7:6], in[7:6]}; // shift by 6 positions
            3'b111: out = {in[4:0], in[7:6], in[7:6], in[7]}; // shift by 7 positions
            default: out = in; // no shift
        endcase
    end

endmodule