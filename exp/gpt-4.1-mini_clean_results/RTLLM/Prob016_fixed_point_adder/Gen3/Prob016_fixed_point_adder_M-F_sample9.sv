module fixed_point_adder #(
    parameter integer Q = 8,  // Number of fractional bits
    parameter integer N = 16  // Total number of bits (integer + fractional)
)(
    input  wire signed [N-1:0] a,
    input  wire signed [N-1:0] b,
    output wire signed [N-1:0] c
);

    // Internal signals for absolute values
    wire [N-1:0] abs_a;
    wire [N-1:0] abs_b;

    // Compute absolute values of a and b
    assign abs_a = (a[N-1] == 1'b1) ? (~a + 1'b1) : a;
    assign abs_b = (b[N-1] == 1'b1) ? (~b + 1'b1) : b;

    reg signed [N-1:0] res;

    always @* begin
        if (a[N-1] == b[N-1]) begin
            // Same sign: add absolute values, sign remains
            res = a + b;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if (abs_a >= abs_b) begin
                // Result sign same as a's sign
                res = (a[N-1] == 1'b1) ? -($signed(abs_a) - $signed(abs_b)) : ($signed(abs_a) - $signed(abs_b));
            end else begin
                // Result sign same as b's sign
                res = (b[N-1] == 1'b1) ? -($signed(abs_b) - $signed(abs_a)) : ($signed(abs_b) - $signed(abs_a));
            end
        end
    end

    assign c = res;

endmodule