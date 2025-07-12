module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Calculate total shift amount from ctrl bits (each bit contributes 1,2,4)
    wire [2:0] shift_amount = ctrl[0] + (ctrl[1] << 1) + (ctrl[2] << 2);
    // Rotate right by shift_amount
    assign out = (in >> shift_amount) | (in << (8 - shift_amount));
endmodule