module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Generate masks that enable lower bits only if higher bits are zero
    wire [3:0] mask3 = in;
    wire [3:0] mask2 = {1'b0, in[2:0]};
    wire [3:0] mask1 = {2'b00, in[1:0]};
    wire [3:0] mask0 = {3'b000, in[0]};

    // Determine if each bit is the first set bit
    wire bit3_first = in[3];
    wire bit2_first = ~in[3] & in[2];
    wire bit1_first = ~in[3] & ~in[2] & in[1];
    wire bit0_first = ~in[3] & ~in[2] & ~in[1] & in[0];

    // Encode the position
    assign pos[1] = bit3_first | bit2_first;
    assign pos[0] = bit3_first | bit1_first;

    // All zeros case is naturally handled (pos = 00)
endmodule