module fixed_point_subtractor #(parameter Q = 8, parameter N = 16) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Internal signed representations for arithmetic
    // Interpret inputs as signed fixed-point numbers
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    reg signed [N-1:0] res;

    // Absolute values for a and b
    wire [N-1:0] abs_a = (a_signed[N-1]) ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = (b_signed[N-1]) ? (~b + 1'b1) : b;

    always @(*) begin
        if (a_signed[N-1] == b_signed[N-1]) begin
            // Same sign subtraction: res = a - b, sign same as inputs
            res = a_signed - b_signed;
        end else begin
            // Different signs: add absolute values
            // Determine sign based on which absolute value is greater
            if (abs_a >= abs_b) begin
                res = a_signed[N-1] ? -($signed(abs_a) + $signed(abs_b)) : $signed(abs_a) + $signed(abs_b);
            end else begin
                res = b_signed[N-1] ? $signed(abs_b) + $signed(abs_a) : -($signed(abs_b) + $signed(abs_a));
            end
        end

        // Handle zero result sign bit explicitly
        if (res == 0) begin
            c = {1'b0, {N-1{1'b0}}};
        end else begin
            c = res;
        end
    end

endmodule