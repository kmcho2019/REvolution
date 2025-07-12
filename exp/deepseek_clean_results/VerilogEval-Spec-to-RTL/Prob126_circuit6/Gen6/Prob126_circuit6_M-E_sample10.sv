module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Intermediate terms
wire [3:0] t1 = {a[2], a[1], a[0], 1'b1};
wire [3:0] t2 = {a[1], a[0], a[2], a[1]};
wire [3:0] t3 = {a[0], a[2], a[1], a[0]};

// Output calculation using non-linear mixing
assign q[15] = t1[3] ^ t2[2];
assign q[14] = t1[2] & t3[1];
assign q[13] = t2[3] | t3[0];
assign q[12] = t1[1] ^ t3[2];
assign q[11] = t2[1] & t1[0];
assign q[10] = t3[3] | t2[0];
assign q[9]  = t1[2] ^ t3[1];
assign q[8]  = t2[2] & t1[3];
assign q[7]  = t3[2] | t1[1];
assign q[6]  = t2[3] ^ t3[0];
assign q[5]  = t1[0] & t2[1];
assign q[4]  = t3[3] ^ t2[0];
assign q[3]  = t1[3] | t2[2];
assign q[2]  = t3[1] ^ t1[2];
assign q[1]  = t2[0] & t3[3];
assign q[0]  = t1[1] | t3[2];

endmodule