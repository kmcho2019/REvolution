module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    wire [2:0] shift_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);

    // Rotate left by shift_amount
    assign out = (in << shift_amount) | (in >> (8 - shift_amount));

endmodule