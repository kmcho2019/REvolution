module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Combine inputs into 4-bit vector: a is MSB, d is LSB
wire [3:0] idx = {a, b, c, d};

// Correct LUT:
// 1 at positions 2(0010), 7(0111), 15(1111), else 0
// bit15..bit0 = 1 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0
localparam [15:0] LUT = 16'b1000000100000100;

assign out_sop = LUT[idx];

// Minimal product-of-sums from zeros:
// zeros: 0(0000),1(0001),4(0100),5(0101),6(0110),
//        9(1001),10(1010),13(1101),14(1110)
// Corresponding maxterms:
// (a + b + c + d)          // for 0(0000)
// (a + b + c + d')         // for 1(0001) simplified later
// (a + b' + c + d)         // for 4(0100)
// (a + b' + c + d')        // for 5(0101)
// (a + b' + c' + d)        // for 6(0110)
// (a' + b + c + d')        // for 9(1001)
// (a' + b + c' + d)        // for 10(1010)
// (a' + b' + c + d')       // for 13(1101)
// (a' + b' + c' + d)       // for 14(1110)

// After minimization (K-map), the minimal POS is:
// out_pos = (a + b + c + d) & (a + b' + c + d') & (a' + b + c' + d);

// Implement these sum terms:
wire sum1 = a | b | c | d;
wire sum2 = a | ~b | c | ~d;
wire sum3 = ~a | b | ~c | d;

assign out_pos = sum1 & sum2 & sum3;

endmodule