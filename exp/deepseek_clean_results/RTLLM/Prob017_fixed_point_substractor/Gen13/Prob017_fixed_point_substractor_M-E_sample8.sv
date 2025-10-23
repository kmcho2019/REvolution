module fixed_point_subtractor #(
    parameter Q = 16,    // Number of fractional bits
    parameter N = 32,    // Total number of bits
    parameter SATURATE = 1  // Enable saturation on overflow
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output wire overflow
);

    // Sign and magnitude separation
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Magnitude comparison
    wire a_gt_b = (a_mag > b_mag);
    wire a_eq_b = (a_mag == b_mag);

    // Early zero detection
    wire is_zero = a_eq_b && (a_sign == b_sign);
    
    // Result sign calculation
    reg res_sign;
    always @(*) begin
        if (is_zero) begin
            res_sign = 1'b0;  // Force positive zero
        end else if (a_sign ^ b_sign) begin
            res_sign = a_sign; // Different signs: result sign matches first operand
        end else begin
            res_sign = (a_sign ^ ~a_gt_b); // Same signs: sign depends on magnitude
        end
    end

    // Magnitude calculation
    reg [N-2:0] res_mag;
    always @(*) begin
        if (is_zero) begin
            res_mag = 0;
        end else if (a_sign == b_sign) begin
            res_mag = a_gt_b ? (a_mag - b_mag) : (b_mag - a_mag);
        end else begin
            res_mag = a_mag + b_mag;  // Different signs: add magnitudes
        end
    end

    // Overflow detection and saturation
    wire raw_overflow = (a_sign == b_sign) ? 
                       (a_gt_b ? (a_mag[N-2] & ~b_mag[N-2] & ~res_mag[N-2]) : 
                                 (b_mag[N-2] & ~a_mag[N-2] & ~res_mag[N-2])) :
                       (&res_mag[N-2:Q]);  // Check integer overflow

    assign overflow = raw_overflow;

    // Final result assembly with optional saturation
    always @(*) begin
        if (SATURATE && raw_overflow) begin
            c = res_sign ? {1'b1, {(N-1){1'b0}}} :  // -MAX
                         {1'b0, {(N-1){1'b1}}};   // +MAX
        end else begin
            c = {res_sign, res_mag};
        end
    end

endmodule