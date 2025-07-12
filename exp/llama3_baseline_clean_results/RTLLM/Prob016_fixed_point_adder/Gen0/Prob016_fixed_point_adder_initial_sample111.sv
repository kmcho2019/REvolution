module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16   // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register for storing the result

// Determine the sign of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine if inputs have the same sign
wire same_sign = (sign_a == sign_b);

// Absolute value of inputs
wire [N-1:0] abs_a = (sign_a)? (~a + 1) : a;
wire [N-1:0] abs_b = (sign_b)? (~b + 1) : b;

// Perform absolute value addition when same sign
wire [N:0] sum = abs_a + abs_b;

// Perform absolute value subtraction when different signs
wire [N-1:0] diff_ab = (abs_a > abs_b)? (abs_a - abs_b) : (abs_b - abs_a);
wire diff_sign = (abs_a > abs_b)? sign_a : sign_b;

// Select result based on sign
always @(a, b) begin
    if (same_sign) begin
        // If overflow, clip to maximum value
        if (sum[N]) begin
            res = (sign_a)? (~0) : 0;
        end else begin
            res = {sign_a, sum[N-1:0]};
        end
    end else begin
        // If result of subtraction is zero, set sign to 0
        if (diff_ab == 0) begin
            res = 0;
        end else begin
            res = diff_ab;
            // Set the sign of the result based on the subtraction
            if (diff_sign) begin
                res = {1'b1, {N-1{1'b1}}};  // Clip to maximum negative if overflow
            end else begin
                res = {1'b0, diff_ab[N-1:0]};
            end
        end
    end
end

assign c = res;

endmodule