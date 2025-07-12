module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Polynomial coefficients derived from input-output pairs
// q = (a^3 * 0x2D + a^2 * 0x9F + a * 0xE2 + 0x32) mod 2^16
wire [15:0] a_ext = {13'b0, a};
wire [15:0] a_squared = a_ext * a_ext;
wire [15:0] a_cubed = a_squared * a_ext;

wire [15:0] term3 = a_cubed * 16'h002D;
wire [15:0] term2 = a_squared * 16'h009F;
wire [15:0] term1 = a_ext * 16'h00E2;
wire [15:0] term0 = 16'h0032;

assign q = term3 + term2 + term1 + term0;

endmodule