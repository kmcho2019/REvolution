module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Calculate the shift amount based on the control signal
wire [2:0] shift_amount;
assign shift_amount = ctrl;

// Use bit manipulation to shift the input
assign out = (shift_amount == 3'b000) ? in :
             (shift_amount == 3'b001) ? {in[6:0], 1'b0} :
             (shift_amount == 3'b010) ? {in[5:0], 2'b00} :
             (shift_amount == 3'b011) ? {in[4:0], 3'b000} :
             (shift_amount == 3'b100) ? {in[3:0], 4'b0000} :
             (shift_amount == 3'b101) ? {in[2:0], 5'b00000} :
             (shift_amount == 3'b110) ? {in[1:0], 6'b000000} :
             {in[0], 7'b0000000};

endmodule