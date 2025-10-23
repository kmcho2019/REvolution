module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Compute total rotate amount as ctrl[2]*4 + ctrl[1]*2 + ctrl[0]*1
    wire [2:0] shift_amount = {ctrl[2], ctrl[1], ctrl[0]};
    
    // Perform left rotate by shift_amount bits
    assign out = (in << shift_amount) | (in >> (8 - shift_amount));

endmodule