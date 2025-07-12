module barrel_shifter(
    input [7:0] in,        // Input data to be rotated
    input [2:0] ctrl,      // Control bits: [2]=4, [1]=2, [0]=1
    output [7:0] out       // Rotated output
);

    // Calculate total rotation amount (0-7)
    wire [2:0] rot_amount = {ctrl[2], ctrl[1], ctrl[0]};

    // Perform circular rotation in one step
    assign out = (in >> rot_amount) | (in << (8 - rot_amount));

    /* Rotation Examples:
       ctrl=3'b000: rot_amount=0, out = in (no rotation)
       ctrl=3'b001: rot_amount=1, right rotate by 1
       ctrl=3'b010: rot_amount=2, right rotate by 2
       ctrl=3'b100: rot_amount=4, right rotate by 4
       ctrl=3'b111: rot_amount=7, right rotate by 7
    */
endmodule