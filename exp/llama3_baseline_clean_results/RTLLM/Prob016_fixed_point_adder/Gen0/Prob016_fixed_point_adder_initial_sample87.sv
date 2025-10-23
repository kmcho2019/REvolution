module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        // Absolute value addition
        if (a[N-1] == 1'b0) begin  // Both positive
            res = a + b;
        end else begin  // Both negative
            res = -(-a + (-b));
        end
    end else begin  // Different signs
        // Absolute value subtraction
        if (a[N-1] == 1'b0) begin  // a is positive, b is negative
            if (a >= -b) begin
                res = a + b;
            end else begin
                res = b + a;
                res = -res;
            end
        end else begin  // a is negative, b is positive
            if (b >= -a) begin
                res = b + a;
            end else begin
                res = -a + b;
                res = -res;
            end
        end
    end

    // Handle overflow
    if (res[N-1] != a[N-1] && res[N] == 1'b1) begin
        res = {1'b1, {N-1{1'b0}}};
    end
end

assign c = res;

endmodule