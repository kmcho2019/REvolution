module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

// Determine the sign bits of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine if the signs are the same or different
wire same_sign = (sign_a == sign_b);

// Perform same-sign subtraction
wire [N-1:0] same_sign_result;
assign same_sign_result = (sign_a)? (a - b) : (a - b);

// Perform different-sign subtraction (adding absolute values)
wire [N-1:0] diff_sign_result;
assign diff_sign_result = (a[N-1] == 1'b0)? (a + (~b + 1'b1)) : ((~a + 1'b1) + b);

// Handle zero result explicitly
wire zero_result = (res == {N{1'b0}});
assign c[N-1] = (zero_result)? 1'b0 : ((same_sign)? sign_a : ((diff_sign_result > {N{1'b0}})? diff_sign_result[N-1] : ~diff_sign_result[N-1]));

// Store the result based on the signs
always @(*) begin
    if (same_sign) begin
        res = same_sign_result;
    end else begin
        res = diff_sign_result;
    end
end

// Output the result
assign c = res;

endmodule