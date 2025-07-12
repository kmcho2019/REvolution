module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

// Define the widths for integer and fractional parts
localparam INTEGER_WIDTH = N - Q;
localparam FRACTIONAL_WIDTH = Q;

// Internal wires for sign handling
wire same_sign;
wire a_positive, b_positive;

// Sign handling logic
assign same_sign = (a[N-1] == b[N-1]);
assign a_positive = ~a[N-1];
assign b_positive = ~b[N-1];

// Integer and fractional parts of inputs
wire [INTEGER_WIDTH-1:0] a_int = a[N-1] ? -a[INTEGER_WIDTH-1:0] : a[INTEGER_WIDTH-1:0];
wire [INTEGER_WIDTH-1:0] b_int = b[N-1] ? -b[INTEGER_WIDTH-1:0] : b[INTEGER_WIDTH-1:0];
wire [FRACTIONAL_WIDTH-1:0] a_frac = a[FRACTIONAL_WIDTH-1:0];
wire [FRACTIONAL_WIDTH-1:0] b_frac = b[FRACTIONAL_WIDTH-1:0];

// Instantiate integer and fractional subtractor modules
wire signed [INTEGER_WIDTH-1:0] int_result;
wire signed [FRACTIONAL_WIDTH-1:0] frac_result;

integer_subtractor #(.WIDTH(INTEGER_WIDTH)) int_sub(a_int, b_int, int_result);
fractional_subtractor #(.WIDTH(FRACTIONAL_WIDTH)) frac_sub(a_frac, b_frac, frac_result);

// Assemble the final result
assign c = {int_result, frac_result};

// Define the integer_subtractor module
module integer_subtractor #(
    parameter WIDTH = 8
)(
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    output signed [WIDTH-1:0] result
);

assign result = a - b;

endmodule

// Define the fractional_subtractor module
module fractional_subtractor #(
    parameter WIDTH = 8
)(
    input signed [WIDTH-1:0] a,
    input signed [WIDTH-1:0] b,
    output signed [WIDTH-1:0] result
);

assign result = a - b;

endmodule

endmodule