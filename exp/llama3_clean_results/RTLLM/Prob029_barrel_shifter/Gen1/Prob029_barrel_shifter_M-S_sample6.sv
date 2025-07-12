module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Calculate the total shift amount
    wire [2:0] shift_amount = ctrl;

    // Perform the shift
    always @(*) begin
        case (shift_amount)
            3'b000: out = in; // No shift
            3'b001: out = {in[6:0], in[7]}; // Shift by 1
            3'b010: out = {in[5:0], in[7:6]}; // Shift by 2
            3'b011: out = {in[5:0], in[7:5]}; // Shift by 3
            3'b100: out = {in[3:0], in[7:4]}; // Shift by 4
            3'b101: out = {in[3:0], in[7:3]}; // Shift by 5
            3'b110: out = {in[3:0], in[7:2]}; // Shift by 6
            3'b111: out = {in[3:0], in[7:1]}; // Shift by 7
            default: out = 8'b0; // Invalid control signal
        endcase
    end

endmodule