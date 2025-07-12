module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res;

always @(a, b) begin
    // Determine the sign of a and b
    reg a_sign = a[N-1];
    reg b_sign = b[N-1];

    // Same sign subtraction
    if (a_sign == b_sign) begin
        res = a - b;
    end
    // Different sign subtraction
    else begin
        // If a is positive and b is negative
        if (~a_sign && b_sign) begin
            if (a > (~b + 1)) begin // If a is greater than absolute value of b
                res = a + (~b + 1);
            end
            else begin
                res = (~b + 1) - a;
                res[N-1] = 1'b1; // Set sign bit to negative
            end
        end
        // If a is negative and b is positive
        else begin
            if ((~a + 1) > b) begin // If absolute value of a is greater than b
                res = (~a + 1) + (~b + 1);
                res[N-1] = 1'b1; // Set sign bit to negative
            end
            else begin
                res = b - (~a + 1);
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 0;
    end

    // Assign result to output
    c = res;
end

endmodule