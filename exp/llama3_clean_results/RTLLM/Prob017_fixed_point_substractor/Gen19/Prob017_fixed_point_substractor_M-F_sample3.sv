module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Extract signs and magnitudes of inputs
wire a_sign = a[N-1];
wire b_sign = b[N-1];
wire [N-2:0] a_mag = a_sign ? {~a[N-2:0] + 1'b1} : a[N-2:0];
wire [N-2:0] b_mag = b_sign ? {~b[N-2:0] + 1'b1} : b[N-2:0];

// Perform subtraction based on signs
wire [N-1:0] res_same_sign;
wire [N-1:0] res_diff_sign;
wire [N-1:0] res;

assign res_same_sign = a_sign ? {~(a_mag - b_mag) + 1'b1} : (a_mag - b_mag);
assign res_diff_sign = a_sign ? (a_mag + b_mag + 1'b1) : (a_mag + b_mag);

assign res = a_sign == b_sign ? res_same_sign : res_diff_sign;

// Assign result to output, handling zero case explicitly
assign c = (res == {N{1'b0}}) ? {N{1'b0}} : res;

endmodule