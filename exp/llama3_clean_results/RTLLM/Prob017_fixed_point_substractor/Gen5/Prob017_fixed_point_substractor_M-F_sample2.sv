module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Sign detection stage
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Absolute value computation
wire [N-1:0] abs_a = sign_a? ~a + 1 : a;
wire [N-1:0] abs_b = sign_b? ~b + 1 : b;

// Comparison and result sign determination
wire result_sign = (sign_a == sign_b)? sign_a : (abs_a < abs_b)? ~sign_a : sign_a;

// Core computation stage
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        if (a >= b) begin
            c = a - b;
        end else begin
            c = ~(~a + 1 - (~b + 1)) + 1;
        end
    end else begin
        // Different sign subtraction
        if (abs_a >= abs_b) begin
            // a is larger, perform subtraction
            if (sign_a == 1'b0) begin
                c = a - b;
            end else begin
                c = ~(~a + 1 - (~b + 1)) + 1;
            end
        end else begin
            // b is larger, perform subtraction with sign adjustment
            if (sign_b == 1'b0) begin
                c = ~(~b + 1 - (~a + 1)) + 1;
            end else begin
                c = b - a;
            end
        end
    end
    // Handling zero result explicitly
    if (c == 0) begin
        c[N-1] = 1'b0; // Set sign bit to 0 for zero result
    end
end

endmodule