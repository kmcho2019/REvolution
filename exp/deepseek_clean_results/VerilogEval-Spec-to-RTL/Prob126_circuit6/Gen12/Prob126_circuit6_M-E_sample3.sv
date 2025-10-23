module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [7:0] left_byte, right_byte;

// Calculate left byte: polynomial approximation
assign left_byte = 8'h12 + (a * 8'h3A) - ((a * a) * 8'h0D);

// Calculate right byte: different polynomial
assign right_byte = 8'h32 + (a * 8'hAE) - ((a * a) * 8'h2F);

// Combine bytes to form output
assign q = {left_byte, right_byte};

endmodule