module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

wire signed [N-Q-1:0] a_int;
wire signed [Q-1:0] a_frac;
wire signed [N-Q-1:0] b_int;
wire signed [Q-1:0] b_frac;

assign a_int = a >> Q;  // Extract integer part of a
assign a_frac = a & ((1 << Q) - 1);  // Extract fractional part of a
assign b_int = b >> Q;  // Extract integer part of b
assign b_frac = b & ((1 << Q) - 1);  // Extract fractional part of b

wire signed [N-Q:0] int_result;
wire signed [Q:0] frac_result;

// Perform integer part subtraction
assign int_result = a_int - b_int;

// Perform fractional part subtraction
assign frac_result = (a_frac - b_frac);

// Combine results, handling carry and sign
assign c = {int_result[N-Q-1], (int_result[N-Q-1:0] + frac_result[Q])} + {frac_result[Q-1:0], 1'b0};

endmodule