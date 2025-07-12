module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire signed [N-1:0] a,
    input wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Parameter validation (synthesizable)
    generate
        if (Q >= N) begin
            // This will cause elaboration error if Q >= N
            illegal_parameter_combination illegal();
        end
    endgenerate

    // Internal signed representation
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] abs_a, abs_b;
    wire a_sign = a_signed[N-1];
    wire b_sign = b_signed[N-1];

    // Absolute values
    assign abs_a = a_sign ? -a_signed : a_signed;
    assign abs_b = b_sign ? -b_signed : b_signed;

    // Main addition/subtraction logic
    reg signed [N:0] result;
    reg result_sign;

    always @(*) begin
        if (a_sign == b_sign) begin
            // Same sign: add magnitudes and keep sign
            result = abs_a + abs_b;
            result_sign = a_sign;
        end
        else begin
            // Different signs: subtract smaller from larger
            if (abs_a > abs_b) begin
                result = abs_a - abs_b;
                result_sign = a_sign;
            end
            else if (abs_b > abs_a) begin
                result = abs_b - abs_a;
                result_sign = b_sign;
            end
            else begin
                // Equal magnitudes: result is zero
                result = 0;
                result_sign = 0;
            end
        end
    end

    // Overflow detection (result exceeds N-1 bits)
    wire overflow = result[N] && (result[N-1:0] != 0);

    // Saturation values
    wire signed [N-1:0] max_val = {1'b0, {(N-1){1'b1}}};
    wire signed [N-1:0] min_val = {1'b1, {(N-1){1'b0}}};

    // Final result with sign application and saturation
    assign c = overflow ? 
              (result_sign ? min_val : max_val) :  // Saturate
              (result_sign ? -result[N-1:0] : result[N-1:0]);  // Apply sign

endmodule