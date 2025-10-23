module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a, b) begin
    // Determine the signs of the input operands
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a > -b) begin
                // a is greater than b, result is positive
                res = a + (~b + 1);
            end else begin
                // b is greater than a, result is negative
                res = - (b + (~a + 1));
            end
        end else begin
            // a is negative, b is positive
            if (-a > b) begin
                // a is greater than b, result is negative
                res = - (a + (~b + 1));
            end else begin
                // b is greater than a, result is positive
                res = b + (~a + 1);
            end
        end
    end
    
    // Handle the case where the result is zero
    if (res == 0) begin
        res[N-1] = 0;
    end
end

assign c = res;

endmodule