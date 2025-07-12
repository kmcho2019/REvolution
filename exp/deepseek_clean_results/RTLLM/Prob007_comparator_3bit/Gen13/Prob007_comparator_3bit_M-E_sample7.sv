module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] diff = {1'b0, A} - {1'b0, B};  // 4-bit to prevent overflow

// Thermometer encoding of difference
wire diff_zero = (diff[2:0] == 3'b000);
wire diff_positive = ~diff[3] & ~diff_zero;
wire diff_negative = diff[3];

// Output assignment (mutually exclusive by construction)
assign A_greater = diff_positive;
assign A_equal = diff_zero;
assign A_less = diff_negative;

endmodule