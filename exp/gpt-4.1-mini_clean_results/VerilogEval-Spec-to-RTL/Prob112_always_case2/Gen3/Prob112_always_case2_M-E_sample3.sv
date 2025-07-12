module TopModule (
    input  [3:0] in,
    output [1:0] pos
);
    wire bit0_sel, bit1_sel, bit2_sel, bit3_sel;

    // bit0_sel is true if bit 0 is set
    assign bit0_sel = in[0];

    // bit1_sel is true if bit1 is set and bit0 is zero
    assign bit1_sel = in[1] & ~in[0];

    // bit2_sel is true if bit2 is set and bit1 and bit0 are zero
    assign bit2_sel = in[2] & ~in[1] & ~in[0];

    // bit3_sel is true if bit3 is set and bit2, bit1, bit0 are zero
    assign bit3_sel = in[3] & ~in[2] & ~in[1] & ~in[0];

    // If no bit is set, all bit*_sel signals are zero, default output is 0
    // Encode position output: bit0_sel means position 0, bit1_sel means 1, etc.
    assign pos[0] = bit1_sel | bit3_sel;
    assign pos[1] = bit2_sel | bit3_sel;
endmodule