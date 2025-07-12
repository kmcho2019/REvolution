module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a > -b) begin
                res = a + ~b + 1;  // Add a and the two's complement of b
            end else begin
                res = ~(-a + b) + 1;  // Two's complement of the sum of -a and b
            end
        end else begin  // a is negative, b is positive
            if (-a > b) begin
                res = ~(-a + b) + 1;  // Two's complement of the sum of -a and b
            end else begin
                res = a + ~b + 1;  // Add a and the two's complement of b
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule