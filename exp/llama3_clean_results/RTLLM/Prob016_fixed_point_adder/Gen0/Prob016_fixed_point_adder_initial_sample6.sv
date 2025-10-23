module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a, // First N-bit fixed-point input operand
    input signed [N-1:0] b, // Second N-bit fixed-point input operand
    output reg signed [N-1:0] c // N-bit output representing the result
);

    reg signed [N-1:0] res; // N-bit register to store the result

    always @(a, b) begin
        // Check signs of a and b
        if (a[N-1] == b[N-1]) begin
            // Same signs, add absolute values
            res = a + b;
            // Check for overflow
            if ((res[N-1]!= a[N-1]) && (a[N-1] == 1'b0)) begin
                // Positive overflow, handle accordingly
                res = {1'b0, {N-1{1'b1}}};
            end else if ((res[N-1]!= a[N-1]) && (a[N-1] == 1'b1)) begin
                // Negative overflow, handle accordingly
                res = {1'b1, {N-1{1'b0}}};
            end
        end else begin
            // Different signs, subtract smaller from larger
            if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
                // a is positive, b is negative
                res = a - (b >>> Q) + (b & ((1 << Q) - 1));
            end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
                // a is negative, b is positive
                res = b - (a >>> Q) + (a & ((1 << Q) - 1));
            end
            // Check for underflow
            if (res[N-1]!= a[N-1] && a[N-1] == 1'b0) begin
                // Underflow handling, result should be zero or positive
                res = {N{1'b0}};
            end else if (res[N-1]!= b[N-1] && b[N-1] == 1'b1) begin
                // Underflow handling, result should be zero or negative
                res = {N{1'b0}};
            end
        end
        c = res;
    end

endmodule