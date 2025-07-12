module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Determine the signs of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Preprocessing stage: Determine the operation based on the signs
wire [N-1:0] abs_a = sign_a ? ~a + 1 : a;  // Absolute value of a
wire [N-1:0] abs_b = sign_b ? ~b + 1 : b;  // Absolute value of b

// Core computation stage
reg signed [N-1:0] res;
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (abs_a > abs_b) begin
            res = abs_a - abs_b;
        end else begin
            res = abs_b - abs_a;
            res = -res;  // Adjust the sign
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        res = 0;
    end
    // Assign the result to the output
    c = res;
end

endmodule