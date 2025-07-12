module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Derive next y[1] from FSM transitions:
    // Analyze transitions for y[1] bit:
    // States: A=000, B=001, C=010, D=011, E=100, F=101
    // Next-state y[1] depends on current y and w according to the given FSM.

    assign Y1 = ((~y[2]) & (y[0] ^ w)) | (y[2] & (~y[1]) & w);

endmodule