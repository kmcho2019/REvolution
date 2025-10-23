module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input logic [N-1:0] a,
    input logic [N-1:0] b,
    output logic [N-1:0] c
);

logic [N-1:0] res;  // Internal register to store the result

// Determine the sign of the inputs
logic sign_a = a[N-1];
logic sign_b = b[N-1];

// Perform subtraction based on the signs of the inputs
always_comb begin
    if (sign_a == sign_b) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (sign_a == 1'b0) begin
            // a is positive, b is negative
            if (a > (b ^ {N{1'b1}}) + 1'b1) begin
                // a is greater than the absolute value of b
                res = a + (b ^ {N{1'b1}}) + 1'b1;
            end else begin
                // a is less than the absolute value of b
                res = (b ^ {N{1'b1}}) + 1'b1 - a;
                // Correctly set the sign bit for the result
                res[N-1] = 1'b1;
            end
        end else begin
            // a is negative, b is positive
            if ((a ^ {N{1'b1}}) + 1'b1 > b) begin
                // The absolute value of a is greater than b
                res = (a ^ {N{1'b1}}) + 1'b1 + b;
                // Correctly set the sign bit for the result
                res[N-1] = 1'b1;
            end else begin
                // The absolute value of a is less than b
                res = b - ((a ^ {N{1'b1}}) + 1'b1);
            end
        end
    end

    // Handle the case where the result is zero
    if (res == 0) begin
        res[N-1] = 1'b0;  // Ensure the sign bit is 0 for a result of 0
    end
end

assign c = res;

endmodule