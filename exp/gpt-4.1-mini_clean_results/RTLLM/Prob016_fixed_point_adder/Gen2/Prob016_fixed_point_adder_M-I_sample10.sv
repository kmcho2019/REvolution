module fixed_point_adder #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Use signed versions of inputs for arithmetic
    wire signed [N-1:0] a_signed = $signed(a);
    wire signed [N-1:0] b_signed = $signed(b);

    // Intermediate variables
    reg signed [N-1:0] result_signed;

    always @* begin
        // Extract sign bits
        wire sign_a = a[N-1];
        wire sign_b = b[N-1];

        if (sign_a == sign_b) begin
            // Same sign: add directly
            result_signed = a_signed + b_signed;
        end else begin
            // Different signs: subtract smaller abs from larger abs
            if ($signed({1'b0,a[N-2:0]}) >= $signed({1'b0,b[N-2:0]})) begin
                result_signed = a_signed - b_signed; // a >= b by magnitude, result sign = sign of a
            end else begin
                result_signed = b_signed - a_signed; // b > a by magnitude, result sign = sign of b
            end
        end

        // Force positive zero (sign bit zero) if result is zero
        if (result_signed == 0)
            result_signed = {1'b0, {(N-1){1'b0}}};

        // Assign result to output
        c = result_signed[N-1:0];
    end

endmodule