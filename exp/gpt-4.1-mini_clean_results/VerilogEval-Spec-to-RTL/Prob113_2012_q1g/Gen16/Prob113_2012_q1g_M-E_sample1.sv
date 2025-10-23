module TopModule(
    input  [3:0] x,
    output       f
);

// Decode input x to one-hot minterms
wire [15:0] minterms;
assign minterms = 16'b1 << (
    (x[2] << 3) | (x[3] << 2) | (x[0] << 1) | x[1]
);

// Minterms with output=1 according to the Karnaugh map:
// minterm numbers: 0,2,8,9,10,12,13,15
// where minterm = x2*8 + x3*4 + x0*2 + x1

assign f = minterms[0] | minterms[2] | minterms[8] | minterms[9] | minterms[10] | minterms[12] | minterms[13] | minterms[15];

endmodule