module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else if (a[N-1] == 0) begin  // a is positive, b is negative
        if (a >= -b) begin
            res = a + (-b);
        end else begin
            res = -(-b - a);
        end
    end else begin  // a is negative, b is positive
        if (-a >= b) begin
            res = -(-a - b);
        end else begin
            res = b - (-a);
        end
    end

    // Handle zero result
    if (res == 0) begin
        res = 0;
    end
end

assign c = res;

endmodule