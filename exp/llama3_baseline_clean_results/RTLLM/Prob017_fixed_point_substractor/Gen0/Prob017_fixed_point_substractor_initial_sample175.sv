module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        if (a[N-1] == 1'b0) begin
            // Both positive
            res = a - b;
        end else begin
            // Both negative
            res = a - b;
        end
    end else begin
        // Different sign subtraction (addition with sign handling)
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive, b is negative
            if (a >= (~b + 1'b1)) begin
                // a is greater than b, result is positive
                res = a + (~b + 1'b1);
            end else begin
                // b is greater than a, result is negative
                res = (~a + 1'b1) + b;
            end
        end else begin
            // a is negative, b is positive
            if ((~a + 1'b1) >= b) begin
                // a is greater than b, result is negative
                res = (~a + 1'b1) - b;
            end else begin
                // b is greater than a, result is positive
                res = b - (~a + 1'b1);
            end
        end
    end

    // Handle zero result
    if (res == {N{1'b0}}) begin
        res[N-1] = 1'b0;  // Set sign bit to 0
    end
end

assign c = res;

endmodule