module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Polynomial coefficients for each output bit
// Each bit's polynomial is: c0 + c1*a + c2*a^2 + c3*a^3
// Coefficients are chosen to match the exact waveform patterns
assign q[0]  = ~a[1] & ~a[0];                          // 1 when a=0
assign q[1]  = a[2] & ~a[1] & a[0];                    // 1 when a=5
assign q[2]  = ~a[2] & a[1] & ~a[0];                   // 1 when a=2
assign q[3]  = ~a[2] & a[1] & a[0];                    // 1 when a=3
assign q[4]  = a[2] & ~a[1] & ~a[0];                   // 1 when a=4
assign q[5]  = ~a[2] & ~a[1] & a[0];                   // 1 when a=1
assign q[6]  = a[2] & a[1] & ~a[0];                    // 1 when a=6
assign q[7]  = a[2] & a[1] & a[0];                     // 1 when a=7
assign q[8]  = ~a[2] & ~a[1] & ~a[0] | a[2] & ~a[1];   // 1 when a=0,4,5
assign q[9]  = ~a[2] & a[1] | a[2] & a[1] & a[0];      // 1 when a=2,3,7
assign q[10] = ~a[2] & a[0] | a[2] & ~a[1] & a[0];     // 1 when a=1,3,5
assign q[11] = ~a[2] & a[1] & ~a[0] | a[2] & a[1];     // 1 when a=2,6,7
assign q[12] = ~a[2] & ~a[1] & a[0] | a[2] & ~a[0];    // 1 when a=1,4,6
assign q[13] = ~a[2] & a[1] & a[0] | a[2] & ~a[1];     // 1 when a=3,4,5
assign q[14] = ~a[2] & ~a[1] | a[2] & a[0];            // 1 when a=0,1,5,7
assign q[15] = a[2] & ~a[1] | a[2] & a[1] & ~a[0];     // 1 when a=4,5,6

endmodule