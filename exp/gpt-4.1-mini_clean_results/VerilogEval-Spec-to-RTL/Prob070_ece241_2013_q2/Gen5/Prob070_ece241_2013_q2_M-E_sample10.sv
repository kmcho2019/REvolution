module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Form 4-bit number with 'a' as MSB, 'd' as LSB
wire [3:0] num = {a, b, c, d};

// Check if num is 2, 7, or 15 for out_sop
assign out_sop = (num == 4'd2) | (num == 4'd7) | (num == 4'd15);

// Minimal POS expression for out_pos derived from zero inputs:
// Zeros: 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)
// Minimal POS: (a + b + ~c + d) & (a + ~b + c + d) & (~a + b + c + d)

// Assign out_pos as product of sums
assign out_pos = (a | b | ~c | d) &
                 (a | ~b |  c | d) &
                 (~a | b |  c | d);

endmodule