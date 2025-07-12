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
wire signed [N-1:0] abs_a = sign_a ? -a : a;  // Absolute value of a
wire signed [N-1:0] abs_b = sign_b ? -b : b;  // Absolute value of b

// Core computation stage
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        c = a - b;
    end else begin
        // Different sign subtraction
        if (abs_a > abs_b) begin
            c = abs_a - abs_b;
        end else begin
            c = abs_b - abs_a;
            c = -c;  // Adjust the sign
        end
    end
    
    // Handle zero result
    if (c == 0) begin
        c = 0;
    end
end

endmodule