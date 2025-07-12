module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Rotate left by 4 bits
    wire [7:0] rot4 = {in[3:0], in[7:4]};
    // Choose input after 4-bit rotation stage
    wire [7:0] after4 = ctrl[2] ? rot4 : in;

    // Rotate left by 2 bits on after4
    wire [7:0] rot2 = {after4[5:0], after4[7:6]};
    // Choose input after 2-bit rotation stage
    wire [7:0] after2 = ctrl[1] ? rot2 : after4;

    // Rotate left by 1 bit on after2
    wire [7:0] rot1 = {after2[6:0], after2[7]};
    // Final output after 1-bit rotation stage
    assign out = ctrl[0] ? rot1 : after2;

endmodule