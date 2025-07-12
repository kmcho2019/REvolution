module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire a0 = a[0];
wire a1 = a[1];
wire a2 = a[2];

// Custom bit manipulation to generate each output pattern
assign q[15] = a2 & ~a1;
assign q[14] = (a2 & a1) | (~a2 & ~a1 & a0);
assign q[13] = (a2 ^ a1) | (a1 & a0);
assign q[12] = (~a2 & a1) | (a2 & ~a0);
assign q[11] = a1 ^ a0;
assign q[10] = (a2 & ~a0) | (~a1 & a0);
assign q[9]  = (a2 & a1 & ~a0) | (~a2 & a0);
assign q[8]  = (~a2 & ~a1) | (a1 & a0);
assign q[7]  = (a2 & ~a1 & a0) | (~a2 & a1);
assign q[6]  = (~a1 & ~a0) | (a2 & a0);
assign q[5]  = (a2 ^ a1 ^ a0);
assign q[4]  = (a1 & ~a0) | (a2 & a0);
assign q[3]  = (~a2 & a1) | (a2 & ~a1 & a0);
assign q[2]  = (a2 & ~a1) | (~a2 & a1 & a0);
assign q[1]  = (~a2 & ~a1 & ~a0) | (a1 & a0);
assign q[0]  = (a2 & a1) | (~a1 & ~a0);

endmodule