module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

// Stage 1: Sign Normalization and Operand Splitting
wire a_normalized = (a[N-1] == 1'b1)? -a : a;
wire b_normalized = (b[N-1] == 1'b1)? -b : b;

wire [N-Q-1:0] a_int = a_normalized[N-1:Q];
wire [Q-1:0] a_frac = a_normalized[Q-1:0];

wire [N-Q-1:0] b_int = b_normalized[N-1:Q];
wire [Q-1:0] b_frac = b_normalized[Q-1:0];

// Stage 2: Integer and Fractional Part Processing
wire [N-Q:0] sum_int;
wire [Q:0] sum_frac;

assign sum_int = a_int + b_int;
assign sum_frac = a_frac + b_frac;

// Handling overflow from fractional part addition
wire carry = (sum_frac[Q] == 1'b1)? 1'b1 : 1'b0;
assign sum_int = (carry == 1'b1)? sum_int + 1 : sum_int;

// Final result construction
assign c[N-1] = (sum_int[N-Q] == 1'b1)? 1'b1 : 1'b0;
assign c[N-2:Q] = sum_int[N-Q-1:0];
assign c[Q-1:0] = sum_frac[Q-1:0];

endmodule