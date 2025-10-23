module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] diff;
wire diff_zero;

// Compute difference A - B
assign diff = A - B;

// Check if difference is zero by NOR of all bits
assign diff_zero = ~(diff[0] | diff[1]);

// Output z is 1 if A equals B, else 0
assign z = diff_zero;

endmodule