module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] diff = A ^ B;
wire [2:0] gt = A & ~B;

// Parallel comparison logic
wire gt2 = gt[2];
wire gt1 = ~diff[2] & gt[1];
wire gt0 = ~diff[2] & ~diff[1] & gt[0];

assign A_greater = gt2 | gt1 | gt0;
assign A_equal = ~(|diff);
assign A_less = ~A_greater & ~A_equal;

endmodule