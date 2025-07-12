module fixed_point_subtractor #(
    parameter integer N = 16, // Total bits (including sign)
    parameter integer Q = 8   // Fractional bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract sign bits (MSB) and magnitude (remaining bits)
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];
    wire [N-2:0] mag_a = a[N-2:0];
    wire [N-2:0] mag_b = b[N-2:0];

    // Intermediate wires for magnitude operations
    wire [N-1:0] mag_a_ext = {1'b0, mag_a}; // Extend with 0 to handle magnitude subtraction/addition without sign
    wire [N-1:0] mag_b_ext = {1'b0, mag_b};

    wire same_sign = (sign_a == sign_b);

    // Magnitude subtraction (always mag_a_ext >= mag_b_ext ? mag_a_ext - mag_b_ext : mag_b_ext - mag_a_ext)
    wire [N-1:0] mag_sub;
    wire a_ge_b = (mag_a_ext >= mag_b_ext);
    assign mag_sub = a_ge_b ? (mag_a_ext - mag_b_ext) : (mag_b_ext - mag_a_ext);

    // Magnitude addition
    wire [N-1:0] mag_add = mag_a_ext + mag_b_ext;

    // Determine result sign and magnitude based on sign conditions
    wire result_sign;
    wire [N-1:0] result_mag;

    // Logic:
    // if same sign: result_sign = sign_a, result_mag = mag_a - mag_b (absolute difference)
    // if different sign:
    //    if a positive and b negative: result = mag_a + mag_b, sign depends on greater magnitude
    //    if a negative and b positive: same as above
    // In both different sign cases, sign determined by which operand has bigger magnitude
    wire [N-1:0] diff_sign_mag = mag_add;

    // Assign result_sign based on cases
    assign result_sign = same_sign ?
                         sign_a :
                         (a_ge_b ? sign_a : sign_b);

    assign result_mag = same_sign ?
                        mag_sub :
                        diff_sign_mag;

    // Check for zero result (magnitude zero)
    wire zero_result = (result_mag == 0);

    // Assemble final output: sign bit + magnitude bits (truncate result_mag to N-1 bits)
    wire [N-1:0] result_full = {result_sign, result_mag[N-2:0]};

    // If zero result, override sign bit to 0
    assign c = zero_result ? {1'b0, {N-1{1'b0}}} : result_full;

endmodule