module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);
    reg signed [N-1:0] res;

    // Internal signals
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    wire [N-1:0] mag_a = sign_a ? (~a + 1'b1) : a; // absolute value of a
    wire [N-1:0] mag_b = sign_b ? (~b + 1'b1) : b; // absolute value of b

    always @(*) begin
        if (sign_a == sign_b) begin
            // Same sign subtraction: res = a - b (signed)
            // Result sign is same as inputs' sign
            res = a - b;
        end else begin
            // Different sign: add magnitudes
            if (mag_a >= mag_b) begin
                // Result sign = sign of a
                res = sign_a ? -($signed(mag_a - mag_b)) : $signed(mag_a - mag_b);
            end else begin
                // Result sign = sign of b (opposite of a)
                res = sign_b ? -($signed(mag_b - mag_a)) : $signed(mag_b - mag_a);
            end
        end

        // Handle zero: force sign bit to zero
        if (res == 0)
            res = {1'b0, {(N-1){1'b0}}};
    end

    assign c = res;

endmodule