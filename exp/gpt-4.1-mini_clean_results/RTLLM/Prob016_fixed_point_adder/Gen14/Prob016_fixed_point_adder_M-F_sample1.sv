module fixed_point_adder #(
    parameter integer Q = 8,      // Number of fractional bits (precision)
    parameter integer N = 16      // Total number of bits including sign and fractional bits
)(
    input  wire [N-1:0] a,        // First N-bit fixed-point input operand (two's complement)
    input  wire [N-1:0] b,        // Second N-bit fixed-point input operand (two's complement)
    output wire [N-1:0] c         // N-bit output representing the result of the fixed-point addition
);

    // Extract sign bits (MSB)
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Compute absolute values of a and b
    // If sign bit is 1, take two's complement to get magnitude
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Determine if signs are equal
    wire sign_eq = (a_sign == b_sign);

    // Magnitude comparison
    wire a_gt_b_mag = (a_mag > b_mag);

    // Internal wires for magnitude operations (N bits to cover carry)
    wire [N-1:0] add_mag;        // Sum of magnitudes for addition case
    wire [N-1:0] sub_mag;        // Difference of magnitudes for subtraction case

    // Perform magnitude addition (N bits to cover carry)
    assign add_mag = {1'b0, a_mag} + {1'b0, b_mag};

    // Perform magnitude subtraction (larger magnitude - smaller magnitude)
    assign sub_mag = a_gt_b_mag ?
                     ({1'b0, a_mag} - {1'b0, b_mag}) :
                     ({1'b0, b_mag} - {1'b0, a_mag});

    // Compose result sign bit:
    // - if signs equal: same as inputs' sign
    // - if signs differ: sign of operand with larger magnitude,
    //   zero result treated as positive zero (sign=0)
    wire result_sign = sign_eq ? a_sign : (sub_mag == 0 ? 1'b0 : (a_gt_b_mag ? a_sign : b_sign));

    // Compose final magnitude (N-1 bits) depending on operation
    wire [N-2:0] result_mag = sign_eq ? add_mag[N-2:0] : sub_mag[N-2:0];

    // Compose final result by concatenating sign and magnitude
    wire [N-1:0] res = {result_sign, result_mag};

    // Output assignment
    assign c = res;

endmodule

/*
Example instantiation in a testbench to avoid parameter passing errors:

fixed_point_adder #(
    .Q(8),
    .N(16)
) fp_adder_inst (
    .a(a_signal),
    .b(b_signal),
    .c(c_signal)
);

Ensure your testbench passes parameters explicitly if different from defaults,
or rely on the default parameters defined above.
*/