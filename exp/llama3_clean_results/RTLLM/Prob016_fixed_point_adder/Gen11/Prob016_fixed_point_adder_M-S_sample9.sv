module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Determine the signs of a and b
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Calculate the sum or difference based on the signs of a and b
wire [N:0] temp;
assign temp = (a_sign == b_sign)? (a + b) : (a > b)? (a - (~b + 1'b1)) : ((~a + 1'b1) - b);

// Handle overflow
assign c = temp[N] == 1'b1? {1'b0, temp[N-1:0]} : temp[N:0];

endmodule