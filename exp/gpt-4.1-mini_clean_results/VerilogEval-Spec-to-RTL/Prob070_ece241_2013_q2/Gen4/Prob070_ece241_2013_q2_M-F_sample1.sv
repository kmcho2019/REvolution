module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Combine inputs into a 4-bit index: a is MSB, d is LSB
wire [3:0] idx = {a,b,c,d};

// 16-bit LUT: bit position corresponds to input number (0-15)
// Output=1 for inputs 2(0010),7(0111),15(1111), else 0
// Bits: bit15..bit0 = 1 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0
localparam [15:0] LUT = 16'b1000000010000100;

assign out_sop = LUT[idx];

// Minimal Product-of-Sums form for outputs 2,7,15 is:
// out_pos = (a + b + d) * (a + c + d) * (b + c + d)
assign out_pos = (a | b | d) & (a | c | d) & (b | c | d);

endmodule