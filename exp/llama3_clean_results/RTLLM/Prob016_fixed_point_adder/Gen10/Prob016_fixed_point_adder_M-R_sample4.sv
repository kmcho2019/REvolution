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

// Calculate the absolute values of a and b
wire [N-1:0] a_abs = (a_sign == 1'b0)? a : ~a + 1'b1;
wire [N-1:0] b_abs = (b_sign == 1'b0)? b : ~b + 1'b1;

// Calculate the result based on the signs of a and b
wire [N-1:0] sum;
wire [N-1:0] diff;

assign sum = a_abs + b_abs;
assign diff = (a_abs > b_abs)? a_abs - b_abs : b_abs - a_abs;

// Determine the result based on the signs of a and b
wire [N-1:0] result;
assign result = (a_sign == b_sign)? sum : diff;

// Assign the result to the output, handling overflow
wire [N-1:0] c_temp;
assign c_temp = (result[N-1] == 1'b1 && a_sign == 1'b0 && b_sign == 1'b0)? {1'b0, result[N-2:0]} + 1'b1 : 
               (result[N-1] == 1'b0 && a_sign == 1'b1 && b_sign == 1'b1)? {1'b1, result[N-2:0]} + 1'b1 : 
               result;

assign c = c_temp;

endmodule