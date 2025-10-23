module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

// Determine the sign of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Same sign subtraction
wire same_sign = sign_a == sign_b;
wire [N-1:0] same_sign_res = a - b;

// Different sign subtraction
wire different_sign = sign_a!= sign_b;
wire [N-1:0] a_abs = ~sign_a? {~a[N-1], a[N-2:0]} + 1 : a;
wire [N-1:0] b_abs = ~sign_b? {~b[N-1], b[N-2:0]} + 1 : b;
wire [N-1:0] different_sign_res = sign_a? b_abs - a_abs : a_abs - b_abs;

// Handle zero result
wire zero_result = (same_sign_res == 0) || (different_sign_res == 0);
wire [N-1:0] zero_result_res = {N{1'b0}};

// Select the result based on the signs and zero result
always @(*) begin
    if (zero_result) begin
        res = zero_result_res;
    end else if (same_sign) begin
        res = same_sign_res;
    end else if (different_sign) begin
        res = different_sign_res;
    end
end

assign c = res;

endmodule