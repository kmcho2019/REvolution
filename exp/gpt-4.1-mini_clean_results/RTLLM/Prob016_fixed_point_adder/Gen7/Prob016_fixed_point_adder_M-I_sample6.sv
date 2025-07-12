module fixed_point_adder #(
    parameter integer Q = 8,        // Number of fractional bits
    parameter integer N = 16        // Total bits including sign bit
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

    // Local signed type for intermediate computations
    // Extend by 1 bit to detect overflow in addition
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Function to compute absolute value of N-bit two's complement number
    function [N-1:0] abs_val(input [N-1:0] val);
        begin
            if (val[N-1] == 1'b0)
                abs_val = val;
            else
                abs_val = (~val) + 1'b1;
        end
    endfunction

    wire [N-1:0] abs_a = abs_val(a);
    wire [N-1:0] abs_b = abs_val(b);

    // For addition or subtraction, extend width to N+1 bits to detect overflow
    wire [N:0] add_res = {1'b0, abs_a} + {1'b0, abs_b}; // sum of abs vals, no sign
    wire [N:0] sub_res_ab = {1'b0, abs_a} - {1'b0, abs_b}; // abs_a - abs_b
    wire [N:0] sub_res_ba = {1'b0, abs_b} - {1'b0, abs_a}; // abs_b - abs_a

    // Saturation limits for N-bit signed fixed-point numbers
    localparam signed [N-1:0] MAX_VAL =  (1 << (N-1)) - 1;
    localparam signed [N-1:0] MIN_VAL = -(1 << (N-1));

    always @* begin
        reg [N-1:0] res_abs;
        reg res_sign;
        reg overflow;

        if (sign_a == sign_b) begin
            // Same sign: add absolute values
            // Check for overflow if result exceeds max positive value representable
            overflow = (add_res[N] == 1'b1) || (add_res[N-1:0] > MAX_VAL);
            if (overflow) begin
                // Saturate
                res_abs = MAX_VAL;
                res_sign = sign_a; // Keep the sign (both same)
            end else begin
                res_abs = add_res[N-1:0];
                res_sign = sign_a;
            end
        end else begin
            // Different signs: subtract smaller absolute value from larger
            if (abs_a == abs_b) begin
                // Result zero
                res_abs = {N{1'b0}};
                res_sign = 1'b0; // sign zero positive
            end else if (abs_a > abs_b) begin
                // a magnitude greater => result sign = sign_a (0: pos, 1: neg)
                res_abs = sub_res_ab[N-1:0];
                res_sign = sign_a;
            end else begin
                // b magnitude greater => result sign = sign_b
                res_abs = sub_res_ba[N-1:0];
                res_sign = sign_b;
            end
            // No overflow possible in subtraction of smaller magnitude from larger
        end

        // Compose result from sign and magnitude
        // If sign = 1, convert magnitude to two's complement negative
        if (res_sign == 1'b0) begin
            c = res_abs;
        end else begin
            c = (~res_abs) + 1'b1;
        end
    end

endmodule