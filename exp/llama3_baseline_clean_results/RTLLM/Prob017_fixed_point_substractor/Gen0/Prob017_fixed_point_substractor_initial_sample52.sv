module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

// Determine the signs of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Calculate the absolute values of the inputs
wire [N-1:0] abs_a = sign_a? ~a + 1 : a;
wire [N-1:0] abs_b = sign_b? ~b + 1 : b;

// Perform subtraction or addition based on the signs
always @(*) begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign addition
        if (abs_a >= abs_b) begin
            // a is greater, result is positive
            res = abs_a + abs_b;
        end else begin
            // b is greater, result is negative
            res = abs_b + abs_a;
            res = ~res + 1;  // Convert to negative
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        res = 0;  // Sign bit is explicitly set to 0
    end
end

assign c = res;

endmodule