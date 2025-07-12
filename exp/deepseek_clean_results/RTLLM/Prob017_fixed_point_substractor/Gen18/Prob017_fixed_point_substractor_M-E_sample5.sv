module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Extract signs and magnitudes
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_larger = (a_mag > b_mag);

    // Determine effective operation
    wire do_addition = (a_sign ^ b_sign);
    wire [N-1:0] operand_a = {1'b0, a_mag};
    wire [N-1:0] operand_b = do_addition ? {1'b0, b_mag} : ~{1'b0, b_mag} + 1;

    // Core arithmetic operation
    wire [N-1:0] raw_result = operand_a + operand_b;
    wire [N-2:0] result_mag = raw_result[N-2:0];
    wire result_overflow = raw_result[N-1];

    // Result sign calculation
    wire result_sign;
    assign result_sign = do_addition ? 
                        (a_sign ? (a_larger ? 1'b1 : 1'b0) : (a_larger ? 1'b0 : 1'b1)) :
                        a_sign;

    // Zero detection and correction
    wire is_zero = (result_mag == 0);
    wire final_sign = is_zero ? 1'b0 : result_sign;

    // Overflow handling (saturate to max/min values)
    wire [N-1:0] overflow_result = result_sign ? {1'b1, {(N-1){1'b0}}} : {1'b0, {(N-1){1'b1}};
    
    // Final result assembly
    assign c = result_overflow ? overflow_result : 
               {final_sign, result_mag};

endmodule