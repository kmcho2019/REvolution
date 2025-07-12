module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   signed [N-1:0] a,
    input   signed [N-1:0] b,
    output  signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(a or b) begin
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        // Same sign subtraction
        res = a - b;
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive, b is negative
            if (a > (-b)) begin
                // Result is positive
                res = a + (-b);
            end else begin
                // Result is negative
                res = (-b) - a;
            end
        end else begin
            // a is negative, b is positive
            if ((-a) > b) begin
                // Result is negative
                res = (-a) - b;
            end else begin
                // Result is positive
                res = b - (-a);
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res = 0;
    end
end

assign c = res;

endmodule