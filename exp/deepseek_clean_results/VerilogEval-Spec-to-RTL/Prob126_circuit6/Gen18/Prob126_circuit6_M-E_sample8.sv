module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Each output bit is computed independently based on input bits
assign q[0] = (~a[2] & ~a[1] & a[0]) | (a[2] & ~a[1] & ~a[0]) | (a[2] & a[1] & a[0]);
assign q[1] = (~a[2] & a[1] & ~a[0]) | (a[2] & ~a[1]) | (a[2] & a[0]);
assign q[2] = (~a[2] & a[1]) | (a[2] & ~a[1] & ~a[0]) | (a[1] & a[0]);
assign q[3] = (a[2] ^ a[1]) | (~a[1] & a[0]);
assign q[4] = (~a[2] & a[0]) | (a[1] & ~a[0]) | (a[2] & ~a[1]);
assign q[5] = (a[2] & ~a[0]) | (~a[1] & a[0]) | (~a[2] & a[1]);
assign q[6] = (a[2] & a[1]) | (~a[2] & ~a[1] & a[0]) | (a[1] & ~a[0]);
assign q[7] = (a[2] & ~a[1] & a[0]) | (~a[2] & a[1] & ~a[0]) | (a[2] & a[1] & ~a[0]);
assign q[8] = (~a[2] & ~a[0]) | (a[1] & a[0]) | (a[2] & ~a[1]);
assign q[9] = (a[2] ^ a[0]) | (a[1] & ~a[0]);
assign q[10] = (~a[2] & a[1] & a[0]) | (a[2] & ~a[1]) | (a[2] & ~a[0]);
assign q[11] = (a[2] & a[1]) | (~a[1] & a[0]) | (~a[2] & a[1] & ~a[0]);
assign q[12] = (~a[2] & ~a[1]) | (a[1] & ~a[0]) | (a[2] & a[0]);
assign q[13] = (a[2] & ~a[1] & ~a[0]) | (~a[2] & a[0]) | (a[1] & a[0]);
assign q[14] = (~a[2] & a[1]) | (a[2] & ~a[0]) | (a[1] & a[0]);
assign q[15] = (a[2] & ~a[1] & a[0]) | (~a[2] & a[1]) | (a[2] & a[1] & ~a[0]);

endmodule