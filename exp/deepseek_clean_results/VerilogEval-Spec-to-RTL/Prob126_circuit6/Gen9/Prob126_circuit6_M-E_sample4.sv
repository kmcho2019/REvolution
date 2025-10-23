module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Polynomial coefficients derived from input-output pairs
// q = 0x1232 + 0x9BAE*a + 0xE5A0*a² + 0x2C00*a³ (mod 2^16)
wire [15:0] a_squared = a * a;
wire [15:0] a_cubed = a_squared * a;
wire [15:0] term1 = 16'h1232;
wire [15:0] term2 = a * 16'h9BAE;
wire [15:0] term3 = a_squared * 16'hE5A0;
wire [15:0] term4 = a_cubed * 16'h2C00;

assign q = term1 + term2 + term3 + term4;

endmodule