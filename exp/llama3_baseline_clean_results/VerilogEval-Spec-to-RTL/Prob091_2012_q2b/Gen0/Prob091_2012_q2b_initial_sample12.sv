module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// One-hot encoding state assignment
// y[5:0] = 000001 (A), 000010 (B), 000100 (C), 001000 (D), 010000 (E), 100000 (F)

// Derive next state logic by inspection
// For Y1 (y[1]), it is set when the next state is B (000010) or D (001000) or E (010000)
assign Y1 = (y[0] &&!w) || (y[1] &&!w) || (y[3] && w) || (y[4] &&!w);

// For Y3 (y[3]), it is set when the next state is D (001000)
assign Y3 = (y[1] &&!w) || (y[2] &&!w) || (y[3] &&!w) || (y[4] && w);

endmodule