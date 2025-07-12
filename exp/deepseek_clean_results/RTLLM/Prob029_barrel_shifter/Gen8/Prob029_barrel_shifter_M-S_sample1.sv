module barrel_shifter (
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);

    // Calculate total shift amount (0-7)
    wire [2:0] shift_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);
    
    // Perform rotation using concatenation and selection
    assign out = (in >> shift_amount) | (in << (8 - shift_amount));

endmodule