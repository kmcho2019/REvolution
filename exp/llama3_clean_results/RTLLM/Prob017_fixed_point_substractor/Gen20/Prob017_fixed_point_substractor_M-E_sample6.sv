module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

// Internal register to store the result
reg signed [N-1:0] res;

// Sign detector
wire a_sign = (a[N-1] == 1'b1);
wire b_sign = (b[N-1] == 1'b1);

// Zero handler
wire is_zero = (a == b);

// Temporary variables for integer and fractional parts
reg signed [N-Q-1:0] int_part_a;
reg signed [N-Q-1:0] int_part_b;
reg signed [Q-1:0] frac_part_a;
reg signed [Q-1:0] frac_part_b;

// Integer part subtraction
always @(*) begin
    int_part_a = a >> Q;
    int_part_b = b >> Q;
end

// Fractional part subtraction
always @(*) begin
    frac_part_a = a % (1 << Q);
    frac_part_b = b % (1 << Q);
end

// Subtraction logic
always @(*) begin
    if (a_sign && b_sign) begin
        // Same sign subtraction
        res = (int_part_a - int_part_b) << Q;
        res = res + (frac_part_a - frac_part_b);
    end else if (!a_sign &&!b_sign) begin
        // Different sign subtraction (both positive)
        if (int_part_a > int_part_b) begin
            res = (int_part_a - int_part_b) << Q;
            res = res + (frac_part_a - frac_part_b);
        end else begin
            res = -(int_part_b - int_part_a) << Q;
            res = res - (frac_part_b - frac_part_a);
        end
    end else if (a_sign &&!b_sign) begin
        // a is negative, b is positive
        res = -(int_part_a + int_part_b) << Q;
        res = res - (frac_part_a + frac_part_b);
    end else begin
        // a is positive, b is negative
        res = (int_part_a + int_part_b) << Q;
        res = res + (frac_part_a + frac_part_b);
    end

    // Zero handler
    if (is_zero) begin
        res = 0;
    end
end

// Assign the result to the output
assign c = res;

endmodule