module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Check if the signs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            if (a >= ~b + 1) begin
                // a is greater than b, result is positive
                res = a + ~b + 1;
            end else begin
                // a is less than b, result is negative
                res = ~b + 1 - a;
            end
        end else begin
            // a is negative, b is positive
            if (~a + 1 >= b) begin
                // a is greater than b, result is negative
                res = ~a + 1 - b;
            end else begin
                // a is less than b, result is positive
                res = b - (~a + 1);
            end
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule