module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] diff = A ^ B;
wire equal = ~(|diff);  // NOR of all difference bits

assign A_equal = equal;

// MSB first comparison
wire greater_msb = A[2] & ~B[2];
wire less_msb = ~A[2] & B[2];
wire eq_msb = ~diff[2];

// Middle bit comparison
wire greater_mid = eq_msb & A[1] & ~B[1];
wire less_mid = eq_msb & ~A[1] & B[1];
wire eq_mid = eq_msb & ~diff[1];

// LSB comparison
wire greater_lsb = eq_mid & A[0] & ~B[0];
wire less_lsb = eq_mid & ~A[0] & B[0];

assign A_greater = greater_msb | greater_mid | greater_lsb;
assign A_less = less_msb | less_mid | less_lsb;

endmodule