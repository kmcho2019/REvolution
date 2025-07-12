module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Compute total rotate amount from ctrl bits (each bit corresponds to shift by 1,2,4)
    wire [2:0] rotate_amt = ctrl;

    // Rotate left by rotate_amt positions
    assign out = (in << rotate_amt) | (in >> (8 - rotate_amt));

endmodule