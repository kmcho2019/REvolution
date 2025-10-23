module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Constants for saturation
    localparam MAX_POS = {1'b0, {(N-1){1'b1}}};
    localparam MAX_NEG = {1'b1, {(N-1){1'b0}}};

    // Stage 1: Input Conversion to Sign-Magnitude
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a_sign ? (~a[N-2:0] + 1'b1) : a[N-2:0];
    wire [N-2:0] b_mag = b_sign ? (~b[N-2:0] + 1'b1) : b[N-2:0];

    // Stage 2: Operation Determination
    wire op_mode = (a_sign == b_sign);  // 1=add, 0=subtract
    wire cmp = (a_mag > b_mag);         // Magnitude comparison

    // Stage 3: Early Overflow Prediction
    wire potential_overflow = op_mode & 
                            ((a_mag[N-2] & b_mag[N-2]) | 
                            (a_mag[N-2] & ~a_mag[N-3] & b_mag[N-3]) |
                            (b_mag[N-2] & ~b_mag[N-3] & a_mag[N-3]));

    // Stage 4: Unified Arithmetic Unit
    wire [N-1:0] arithmetic_result;
    wire [N-2:0] sum_mag = a_mag + b_mag;
    wire [N-2:0] diff_mag = cmp ? (a_mag - b_mag) : (b_mag - a_mag);
    
    assign arithmetic_result = op_mode ? 
                             (potential_overflow ? 
                              (a_sign ? MAX_NEG : MAX_POS) : 
                              {a_sign, sum_mag}) :
                             {cmp ? a_sign : b_sign, diff_mag};

    // Stage 5: Final Conversion and Output
    wire result_sign = arithmetic_result[N-1];
    wire [N-2:0] result_mag = arithmetic_result[N-2:0];
    
    assign c = result_sign ? 
              ((result_mag == 0) ? 0 : (~result_mag + 1'b1)) : 
              result_mag;

endmodule