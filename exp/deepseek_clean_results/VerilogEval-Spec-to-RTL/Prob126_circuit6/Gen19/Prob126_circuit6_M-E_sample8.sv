module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Polynomial coefficients derived to match given input-output pairs
localparam [15:0] C0 = 16'h1232;
localparam [15:0] C1 = 16'h9CAE;
localparam [15:0] C2 = 16'h1D4C;
localparam [15:0] C3 = 16'h0F6A;

// Compute polynomial terms
wire [15:0] a_squared = a * a;
wire [15:0] a_cubed = a_squared * a;

// Compute polynomial hash
wire [15:0] term1 = C1 * a;
wire [15:0] term2 = C2 * a_squared;
wire [15:0] term3 = C3 * a_cubed;

// Sum all terms with modular reduction
assign q = (C0 + term1 + term2 + term3) & 16'hFFFF;

endmodule