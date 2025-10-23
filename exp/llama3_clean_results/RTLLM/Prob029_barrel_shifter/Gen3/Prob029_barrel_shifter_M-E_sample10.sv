module barrel_shifter(
    input [7:0] in,   // 8-bit input to be shifted
    input [2:0] ctrl, // 3-bit control signal
    output [7:0] out   // 8-bit shifted output
);

    // Calculate the total shift amount based on the control signal
    wire [2:0] shift_amount;
    assign shift_amount = (ctrl[2] << 2) | (ctrl[1] << 1) | ctrl[0];

    // Perform the shifting
    reg [7:0] temp_out;
    always @(in or ctrl) begin
        case (shift_amount)
            3'b001: temp_out = in >> 1; // Shift by 1 position
            3'b010: temp_out = in >> 2; // Shift by 2 positions
            3'b011: temp_out = {in[6:0], 1'b0}; // Shift by 3 positions (2 + 1)
            3'b100: temp_out = in >> 4; // Shift by 4 positions
            3'b101: temp_out = {in[3:0], 4'b0000}; // Shift by 5 positions (4 + 1)
            3'b110: temp_out = {in[2:0], 5'b00000}; // Shift by 6 positions (4 + 2)
            3'b111: temp_out = {in[1:0], 6'b000000}; // Shift by 7 positions (4 + 2 + 1)
            default: temp_out = in; // No shift
        endcase
    end

    assign out = temp_out;

endmodule