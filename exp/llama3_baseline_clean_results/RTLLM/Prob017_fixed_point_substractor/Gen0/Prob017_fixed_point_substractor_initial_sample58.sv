module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        if (a[N-1] == 1'b0) begin // Both positive
            res = a - b;
        end else begin // Both negative
            res = a - b;
        end
    end else begin // Different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
            if (a >= (~b + 1)) begin // a is greater than b
                res = a + (~b + 1);
            end else begin
                res = (~a + 1) + b; // b is greater than a
            end
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin // a is negative, b is positive
            if ((~a + 1) >= b) begin // a is greater than b (in absolute value)
                res = (~a + 1) - b;
            end else begin
                res = b - (~a + 1); // b is greater than a
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;
    end

    c = res;
end

endmodule