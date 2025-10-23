module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    wire [2:0] shift_amt = ctrl; // total rotate amount (0 to 7)

    // Rotate right by shift_amt bits: out = in rotated right by shift_amt
    // This is done by concatenating the bits from 'in' after rotation.
    assign out = (in >> shift_amt) | (in << (8 - shift_amt));

endmodule