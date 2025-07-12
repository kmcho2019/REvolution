module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   wire [N-1:0] a,
    input   wire [N-1:0] b,
    output  wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Determine the sign of the inputs
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        wire [N-1:0] abs_a = sign_a? -a : a;
        wire [N-1:0] abs_b = sign_b? -b : b;

        if (abs_a >= abs_b) begin
            // Result is positive if a is greater than b
            res = abs_a - abs_b;
        end else begin
            // Result is negative if a is less than b
            res = -(abs_b - abs_a);
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 0;  // Set sign bit to 0
    end
end

assign c = res;  // Output the result

endmodule