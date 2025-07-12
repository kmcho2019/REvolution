// Novel 8-bit Barrel Shifter module
module barrel_shifter(
    input  [7:0] in,
    input  [2:0] ctrl,
    output [7:0] out
);

    // Lookup table for shift amounts based on control signal
    wire [2:0] shift_amount;
    always @(*) begin
        case(ctrl)
            3'b001: shift_amount = 3'b001; // Shift by 1 position
            3'b010: shift_amount = 3'b010; // Shift by 2 positions
            3'b011: shift_amount = 3'b011; // Shift by 3 positions (1 + 2)
            3'b100: shift_amount = 3'b100; // Shift by 4 positions
            3'b101: shift_amount = 3'b101; // Shift by 5 positions (4 + 1)
            3'b110: shift_amount = 3'b110; // Shift by 6 positions (4 + 2)
            3'b111: shift_amount = 3'b111; // Shift by 7 positions (4 + 2 + 1)
            default: shift_amount = 3'b000; // No shift
        endcase
    end

    // Perform bitwise rotation based on shift amount
    always @(*) begin
        case(shift_amount)
            3'b001: out = {in[6:0], in[7]}; // Shift by 1 position
            3'b010: out = {in[5:0], in[7:6]}; // Shift by 2 positions
            3'b011: out = {in[4:0], in[7:5]}; // Shift by 3 positions
            3'b100: out = {in[3:0], in[7:4]}; // Shift by 4 positions
            3'b101: out = {in[2:0], in[7:3]}; // Shift by 5 positions
            3'b110: out = {in[1:0], in[7:2]}; // Shift by 6 positions
            3'b111: out = {in[0], in[7:1]}; // Shift by 7 positions
            default: out = in; // No shift
        endcase
    end

endmodule