module TopModule (
    input  [3:0] in,
    output [1:0] pos
);
    // pos[1] = in[3] | in[2];
    // pos[0] = in[3] | ( ~in[2] & in[1] );
    // If no bits set, pos defaults to 0 naturally.

    assign pos[1] = in[3] | in[2];
    assign pos[0] = in[3] | (~in[2] & in[1]);
endmodule