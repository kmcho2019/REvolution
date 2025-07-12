module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Compute signed difference (4 bits to handle all cases)
wire signed [3:0] diff = {1'b0, A} - {1'b0, B};

// One-hot encoded comparison result
wire greater = (diff > 0);
wire equal = (diff == 0);
wire less = (diff < 0);

// Direct assignment of outputs
assign A_greater = greater;
assign A_equal = equal;
assign A_less = less;

endmodule