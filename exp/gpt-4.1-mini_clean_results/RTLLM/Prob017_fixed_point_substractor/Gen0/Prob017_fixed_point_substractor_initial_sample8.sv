module fixed_point_subtractor #(parameter Q = 8, parameter N = 16)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    reg [N-1:0] res;

    // Extract sign bits
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    // Absolute values of a and b (two's complement if negative)
    wire [N-1:0] abs_a = a_sign ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = b_sign ? (~b + 1'b1) : b;

    // Perform subtraction or addition depending on sign
    always @* begin
        if (a_sign == b_sign) begin
            // Same sign: subtract b from a
            res = a - b;
        end else begin
            // Different signs: add absolute values
            // Determine sign based on magnitude of abs_a and abs_b
            if (abs_a >= abs_b) begin
                // Result sign same as a's sign
                res = a_sign ? -($signed(abs_a) + $signed(abs_b)) : (abs_a + abs_b);
            end else begin
                // Result sign opposite of a's sign (same as b's sign)
                res = b_sign ? -($signed(abs_b) + $signed(abs_a)) : (abs_b + abs_a);
            end
        end

        // Handle zero: clear sign bit
        if (res == {N{1'b0}}) begin
            res = {1'b0, {(N-1){1'b0}}};
        end

        c = res;
    end

endmodule