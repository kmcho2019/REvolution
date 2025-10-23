module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Calculate the effective shift amount (0-7)
    wire [2:0] shift_amount = ctrl;

    // Generate each output bit by selecting the appropriate input bit
    assign out[0] = in[(0 + shift_amount) % 8];
    assign out[1] = in[(1 + shift_amount) % 8];
    assign out[2] = in[(2 + shift_amount) % 8];
    assign out[3] = in[(3 + shift_amount) % 8];
    assign out[4] = in[(4 + shift_amount) % 8];
    assign out[5] = in[(5 + shift_amount) % 8];
    assign out[6] = in[(6 + shift_amount) % 8];
    assign out[7] = in[(7 + shift_amount) % 8];

endmodule