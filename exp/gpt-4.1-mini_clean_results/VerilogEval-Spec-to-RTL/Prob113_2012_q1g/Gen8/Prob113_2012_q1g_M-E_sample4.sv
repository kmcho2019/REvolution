module TopModule(
    input  [3:0] x,
    output      f
);

wire [1:0] hi = x[3:2]; // High bits: row index in K-map
wire [1:0] lo = x[1:0]; // Low bits: column index in K-map

// Define partial outputs for each 2x2 quadrant of the K-map
// Quadrant 00: x[3:2] = 00
// Map rows: 00 => f=1 at columns 00 and 10 only (lo=2'b00 or 2'b10)
wire f_q00 = (hi == 2'b00) && ( (lo == 2'b00) || (lo == 2'b10) );

// Quadrant 01: x[3:2] = 01
// Map row 01 has all zeros, so output 0 for this quadrant
wire f_q01 = 1'b0;

// Quadrant 11: x[3:2] = 11
// Map row 11 has f=1 at columns 00,01,11 (lo=00,01,11)
wire f_q11 = (hi == 2'b11) && ( (lo == 2'b00) || (lo == 2'b01) || (lo == 2'b11) );

// Quadrant 10: x[3:2] = 10
// Map row 10 has f=1 at columns 00,01,10 (lo=00,01,10)
wire f_q10 = (hi == 2'b10) && ( (lo == 2'b00) || (lo == 2'b01) || (lo == 2'b10) );

// Combine partial results from all quadrants
assign f = f_q00 | f_q01 | f_q10 | f_q11;

endmodule