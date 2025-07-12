module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Calculate total shift amount (0-7)
    wire [2:0] shift = {ctrl[2], 1'b0, 1'b0} + {1'b0, ctrl[1], 1'b0} + {2'b0, ctrl[0]};

    // Generate each output bit by selecting rotated input
    assign out[0] = in[(0 + shift) % 8];
    assign out[1] = in[(1 + shift) % 8];
    assign out[2] = in[(2 + shift) % 8];
    assign out[3] = in[(3 + shift) % 8];
    assign out[4] = in[(4 + shift) % 8];
    assign out[5] = in[(5 + shift) % 8];
    assign out[6] = in[(6 + shift) % 8];
    assign out[7] = in[(7 + shift) % 8];
endmodule