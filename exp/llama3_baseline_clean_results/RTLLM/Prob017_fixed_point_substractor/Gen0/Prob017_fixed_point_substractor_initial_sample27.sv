module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   wire [N-1:0] a,
    input   wire [N-1:0] b,
    output  wire [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the input operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Perform same sign subtraction
    if (sign_a == sign_b) begin
        // Subtract the fractional and integer parts
        res = a - b;
    end else begin
        // Add the absolute values of the inputs
        wire [N-1:0] abs_a = (sign_a) ? (~a + 1) : a;
        wire [N-1:0] abs_b = (sign_b) ? (~b + 1) : b;

        // Determine the sign of the result
        if (abs_a >= abs_b) begin
            res = abs_a - abs_b;
            if (sign_a == 0) begin
                // Result is positive
                res[N-1] = 0;
            end else begin
                // Result is negative
                res[N-1] = 1;
            end
        end else begin
            res = abs_b - abs_a;
            if (sign_a == 0) begin
                // Result is negative
                res[N-1] = 1;
            end else begin
                // Result is positive
                res[N-1] = 0;
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 0;
    end
end

assign c = res;

endmodule