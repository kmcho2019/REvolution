module fixed_point_adder #(
    parameter Q = 8,        // Fractional bits
    parameter N = 16,       // Total bits
    parameter SATURATE = 1   // 0: wrap, 1: saturate
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Constants for saturation
    localparam [N-1:0] MAX_POS = {1'b0, {(N-1){1'b1}};
    localparam [N-1:0] MAX_NEG = {1'b1, {(N-1){1'b0}};

    // Sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Magnitudes (absolute values)
    wire [N-2:0] a_mag = a_sign ? -a[N-2:0] : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? -b[N-2:0] : b[N-2:0];

    // Raw addition/subtraction results
    wire [N-1:0] sum_raw, diff_raw;
    wire [N-1:0] sum_result, diff_result;
    wire [N-1:0] final_result;

    // Case 1: Same signs (addition)
    assign sum_raw = {a_sign, a_mag} + {b_sign, b_mag};
    wire sum_overflow = (a_sign == b_sign) && (sum_raw[N-1] != a_sign);

    // Case 2: Different signs (subtraction)
    wire a_larger = (a_mag > b_mag);
    assign diff_raw = a_larger ? {a_sign, a_mag - b_mag} : {b_sign, b_mag - a_mag};
    wire diff_zero = (a_mag == b_mag);

    // Select appropriate result
    assign sum_result = (SATURATE && sum_overflow) ? 
                       (a_sign ? MAX_NEG : MAX_POS) : sum_raw;
    assign diff_result = diff_zero ? {N{1'b0}} : diff_raw;

    // Final output selection
    assign final_result = (a_sign == b_sign) ? sum_result : diff_result;

    // Apply fixed-point precision (Q parameter affects interpretation only)
    assign c = final_result;

endmodule