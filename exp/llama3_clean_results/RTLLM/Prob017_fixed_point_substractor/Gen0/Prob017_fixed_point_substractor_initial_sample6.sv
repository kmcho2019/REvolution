module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (integer + fractional)
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Determine the signs of the input operands
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Determine if the signs are the same
wire same_sign = (sign_a == sign_b);

// Perform subtraction or addition based on the signs
always @(*) begin
    if (same_sign) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign, add absolute values and determine result sign
        if (a[N-1] == 1'b0) begin  // a is positive
            if (a >= (~b + 1'b1)) begin
                res = a + (~b + 1'b1);
            end else begin
                res = (~b + 1'b1) - a;
                res[N-1] = 1'b1;  // Set sign bit to negative
            end
        end else begin  // a is negative
            if ((~a + 1'b1) >= b) begin
                res = (~a + 1'b1) - b;
            end else begin
                res = b - (~a + 1'b1);
                res[N-1] = 1'b1;  // Set sign bit to negative
            end
        end
    end

    // Handle zero result
    if (res == {N{1'b0}}) begin
        res[N-1] = 1'b0;  // Set sign bit to 0 for zero result
    end
end

// Assign result to output
assign c = res;

endmodule