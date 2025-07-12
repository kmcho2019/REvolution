module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Declare signed versions of inputs for arithmetic
    wire signed [N-1:0] a_s = $signed(a);
    wire signed [N-1:0] b_s = $signed(b);

    // Extract sign bits
    wire a_sign = a_s[N-1];
    wire b_sign = b_s[N-1];

    // Compute absolute values using signed magnitude conversion
    wire signed [N-1:0] abs_a = a_sign ? -a_s : a_s;
    wire signed [N-1:0] abs_b = b_sign ? -b_s : b_s;

    reg signed [N-1:0] res_signed;  // intermediate signed result

    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: subtract smaller magnitude from larger
            if (abs_a >= abs_b) begin
                // Result sign = a_sign, magnitude = abs_a - abs_b
                res_signed = a_sign ? -(abs_a - abs_b) : (abs_a - abs_b);
            end else begin
                // Result sign opposite (same as b_sign), magnitude = abs_b - abs_a
                res_signed = b_sign ? -(abs_b - abs_a) : (abs_b - abs_a);
            end
        end else begin
            // Different sign: add magnitudes
            if (abs_a >= abs_b) begin
                // Result sign = a_sign, magnitude = abs_a + abs_b
                res_signed = a_sign ? -(abs_a + abs_b) : (abs_a + abs_b);
            end else begin
                // Result sign = b_sign, magnitude = abs_b + abs_a
                res_signed = b_sign ? -(abs_b + abs_a) : (abs_b + abs_a);
            end
        end

        // Handle zero: clear sign bit explicitly
        if (res_signed == 0) begin
            c = {1'b0, {(N-1){1'b0}}};
        end else begin
            c = res_signed[N-1:0];
        end
    end

endmodule