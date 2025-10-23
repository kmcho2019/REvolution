module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

// Calculate total shift amount (0-7) from control bits
// ctrl[2]=4, ctrl[1]=2, ctrl[0]=1
wire [2:0] shift_amount = ctrl[2] * 4 + ctrl[1] * 2 + ctrl[0];

// Perform the rotation in one step
assign out = {in, in} >> shift_amount;

endmodule