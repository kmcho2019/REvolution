module fixed_point_adder #(
    parameter integer Q = 8,         // Number of fractional bits
    parameter integer N = 16         // Total bits including sign bit
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Interpret inputs as signed numbers for comparison
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;

    // Extract signs
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Compute absolute values without using a function (improve synthesis)
    wire [N-1:0] abs_a = sign_a ? (~a + 1'b1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1'b1) : b;

    // Extend to N+1 bits for overflow detection in addition
    wire [N:0] add_abs = {1'b0, abs_a} + {1'b0, abs_b};

    // Subtraction results, always positive because subtract smaller from larger
    wire [N:0] sub_ab = (abs_a >= abs_b) ? ({1'b0, abs_a} - {1'b0, abs_b}) : 0;
    wire [N:0] sub_ba = (abs_b >  abs_a) ? ({1'b0, abs_b} - {1'b0, abs_a}) : 0;

    // Saturation limits
    localparam signed [N-1:0] MAX_VAL =  (1 << (N-1)) - 1;
    localparam signed [N-1:0] MIN_VAL = -(1 << (N-1));

    always @* begin
        reg signed [N-1:0] res_val;  // signed result before assignment
        reg overflow;

        if (sign_a == sign_b) begin
            // Same sign: add magnitudes
            overflow = add_abs[N] | (add_abs[N-1:0] > MAX_VAL);

            if (overflow) begin
                // Saturate to max or min depending on sign
                if (sign_a == 1'b0)
                    res_val = MAX_VAL;
                else
                    res_val = MIN_VAL;
            end else begin
                // Safe addition, result sign same as inputs
                res_val = sign_a ? -add_abs[N-1:0] : add_abs[N-1:0];
            end
        end else begin
            // Different signs: subtract smaller magnitude from larger
            if (abs_a == abs_b) begin
                // Result zero
                res_val = 0;
            end else if (abs_a > abs_b) begin
                // Sign of a, positive if sign_a=0 else negative
                res_val = sign_a ? -sub_ab[N-1:0] : sub_ab[N-1:0];
            end else begin
                // Sign of b
                res_val = sign_b ? -sub_ba[N-1:0] : sub_ba[N-1:0];
            end
            // Overflow impossible in subtraction of magnitudes here
        end

        c = res_val;
    end

endmodule