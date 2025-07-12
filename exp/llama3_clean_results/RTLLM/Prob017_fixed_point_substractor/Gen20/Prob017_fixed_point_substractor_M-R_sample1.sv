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

// Define the fixed_point_subtractor module
module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);
    localparam INTEGER_WIDTH = N - Q;
    localparam FRACTIONAL_WIDTH = Q;

    wire [INTEGER_WIDTH-1:0] a_int = a[N-1] ? -a[INTEGER_WIDTH-1:0] : a[INTEGER_WIDTH-1:0];
    wire [INTEGER_WIDTH-1:0] b_int = b[N-1] ? -b[INTEGER_WIDTH-1:0] : b[INTEGER_WIDTH-1:0];
    wire [FRACTIONAL_WIDTH-1:0] a_frac = a[FRACTIONAL_WIDTH-1:0];
    wire [FRACTIONAL_WIDTH-1:0] b_frac = b[FRACTIONAL_WIDTH-1:0];

    wire signed [INTEGER_WIDTH-1:0] int_result;
    wire signed [FRACTIONAL_WIDTH-1:0] frac_result;

    integer_subtractor #(.WIDTH(INTEGER_WIDTH)) int_sub(a_int, b_int, int_result);
    fractional_subtractor #(.WIDTH(FRACTIONAL_WIDTH)) frac_sub(a_frac, b_frac, frac_result);

    assign c = {int_result, frac_result};
endmodule