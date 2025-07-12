module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Calculate total shift amount by summing the weighted ctrl bits:
    // ctrl[0] shifts by 1, ctrl[1] by 2, ctrl[2] by 4
    wire [2:0] shift_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);

    // Perform rotation by shift_amount to the left
    // Rotation is done by concatenating input twice and selecting 8 bits starting at shift_amount
    assign out = (in << shift_amount) | (in >> (8 - shift_amount));
endmodule