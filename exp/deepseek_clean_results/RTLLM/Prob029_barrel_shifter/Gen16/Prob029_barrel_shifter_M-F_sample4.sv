module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Calculate total shift amount (0-7)
    wire [2:0] shift_amount = {ctrl[2], 1'b0, 1'b0} + {1'b0, ctrl[1], 1'b0} + {2'b0, ctrl[0]};
    
    // Create double-width version of input for rotation
    wire [15:0] double_in = {in, in};
    
    // Select the rotated output based on total shift amount
    assign out = double_in[7+shift_amount -:8];
endmodule