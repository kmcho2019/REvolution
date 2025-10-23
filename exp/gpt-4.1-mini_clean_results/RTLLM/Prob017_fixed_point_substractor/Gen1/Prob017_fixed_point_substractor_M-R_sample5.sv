module fixed_point_subtractor #(
    parameter integer Q = 8,      // Number of fractional bits
    parameter integer N = 16      // Total bits width
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire       [N-1:0] c
);

    // Internal signed signals for calculation
    wire signed [N:0] result_ext; // One extra bit to prevent overflow on addition/subtraction

    // Extract sign bits
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Determine if signs are the same
    wire same_sign = (sign_a == sign_b);

    // Compute result depending on signs:
    // Same sign => subtraction (a - b)
    // Different signs => addition (a + (-b) or vice versa, which is a + b in signed)
    wire signed [N:0] subtract_result  = {a[N-1], a} - {b[N-1], b}; // sign-extended subtraction
    wire signed [N:0] add_result       = {a[N-1], a} + {b[N-1], b}; // sign-extended addition

    // Select result based on sign equality
    assign result_ext = same_sign ? subtract_result : add_result;

    // Handle zero result: if all bits except sign are zero, force sign bit to 0
    wire is_zero = (result_ext[N-1:0] == 0);

    // Construct output
    assign c = is_zero ? {1'b0, {N-1{1'b0}}} : result_ext[N-1:0];

endmodule