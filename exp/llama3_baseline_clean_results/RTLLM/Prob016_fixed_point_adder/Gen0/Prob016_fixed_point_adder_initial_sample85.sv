module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32  // Total number of bits, including integer and fractional parts
) (
    input   wire [N-1:0] a,
    input   wire [N-1:0] b,
    output  wire [N-1:0] c
);

// Internal register to store the result
reg [N-1:0] res;

// Determine the sign bits of a and b
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine if the signs of a and b are the same
wire same_sign = (sign_a == sign_b);

// Absolute values of a and b
wire [N-1:0] abs_a = (sign_a)? (~a + 1) : a;
wire [N-1:0] abs_b = (sign_b)? (~b + 1) : b;

// Compare absolute values to determine the larger one
wire [N-1:0] larger_abs = (abs_a > abs_b)? abs_a : abs_b;
wire [N-1:0] smaller_abs = (abs_a > abs_b)? abs_b : abs_a;

// Perform addition or subtraction based on the signs of a and b
always @(*) begin
    if (same_sign) begin
        // Add absolute values and set the sign bit
        res = (sign_a)? ~(larger_abs + smaller_abs - 1) : (larger_abs + smaller_abs);
    end else begin
        // Subtract the smaller absolute value from the larger and set the sign bit
        res = (larger_abs > smaller_abs)? larger_abs - smaller_abs : ~(smaller_abs - larger_abs - 1);
        // If the result is zero or negative, adjust the sign bit accordingly
        if (res == 0 || (res[N-1] == 1 && larger_abs!= smaller_abs)) begin
            res[N-1] = 1'b0; // Set the sign bit to 0 if the result is positive
        end else if (res[N-1] == 0) begin
            res[N-1] = 1'b1; // Set the sign bit to 1 if the result is negative
        end
    end
end

// Assign the result to the output
assign c = res;

endmodule