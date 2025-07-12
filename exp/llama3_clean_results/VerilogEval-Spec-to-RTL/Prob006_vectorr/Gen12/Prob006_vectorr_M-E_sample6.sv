// Module to reverse the bit ordering of an 8-bit input using a barrel shifter approach
module TopModule(
    input  [7:0] in,  // 8-bit input vector
    output [7:0] out // 8-bit output vector
);

    // The shift amount for an 8-bit word to reverse is 7
    parameter SHIFT_AMOUNT = 7;

    // Internal wires to hold the shifted bits
    wire [7:0] shifted_bits;

    // Generate the shifted bits
    assign shifted_bits[0] = in[SHIFT_AMOUNT];
    assign shifted_bits[1] = in[SHIFT_AMOUNT - 1];
    assign shifted_bits[2] = in[SHIFT_AMOUNT - 2];
    assign shifted_bits[3] = in[SHIFT_AMOUNT - 3];
    assign shifted_bits[4] = in[SHIFT_AMOUNT - 4];
    assign shifted_bits[5] = in[SHIFT_AMOUNT - 5];
    assign shifted_bits[6] = in[SHIFT_AMOUNT - 6];
    assign shifted_bits[7] = in[SHIFT_AMOUNT - 7];

    // Output the shifted bits
    assign out = shifted_bits;

endmodule