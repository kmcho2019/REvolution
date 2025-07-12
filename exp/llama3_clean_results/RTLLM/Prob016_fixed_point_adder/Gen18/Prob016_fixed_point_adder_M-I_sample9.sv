module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input             clk, // Clock signal
    input             rst_n, // Active low reset
    input [N-1:0]      a, // First N-bit fixed-point input operand
    input [N-1:0]      b, // Second N-bit fixed-point input operand
    output [N-1:0]     c  // N-bit output representing the result of the fixed-point addition
);

// Determine the signs of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate the absolute values of the inputs
wire [N-1:0] abs_a = sign_a ? (~a + 1) : a;
wire [N-1:0] abs_b = sign_b ? (~b + 1) : b;

// Perform addition or subtraction based on the MSBs
wire [N:0] sum = (sign_a == sign_b) ? abs_a + abs_b : (abs_a > abs_b) ? abs_a - abs_b : abs_b - abs_a;

// Handle overflow and determine the sign of the result
wire sign_c = (sign_a == sign_b) ? sign_a : (abs_a > abs_b) ? 1'b0 : (sum[N] == 1'b1 && sum[N-1:0] == 0) ? 1'b0 : 1'b1;

// Saturate the result to handle overflow
reg [N-1:0] res;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        res <= {N{1'b0}};
    end else begin
        if (sum[N] == 1'b1) begin
            // Saturate to maximum value on overflow
            res <= (sign_c) ? {1'b1, {N-1{1'b1}}} : {N{1'b0}};
        end else begin
            // Assign the result, handling sign
            res <= (sign_c) ? {sign_c, sum[N-1:1]} : {1'b0, sum[N-1:1]};
        end
    end
end

assign c = res;

endmodule