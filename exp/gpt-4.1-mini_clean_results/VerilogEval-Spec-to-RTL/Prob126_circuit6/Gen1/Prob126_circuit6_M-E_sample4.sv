module TopModule (
    input  [2:0] a,
    output [15:0] q
);

// Constant multiplier value based on waveform observations
localparam [15:0] MULT_CONST = 16'h1232;

// Intermediate 19-bit product (since 3-bit * 16-bit = max 19 bits)
wire [18:0] product = a * MULT_CONST;

// Rotate left by 4 bits (circular shift of 16-bit portion)
wire [15:0] rotated = {product[14:0], product[18:15]};

assign q = rotated;

endmodule