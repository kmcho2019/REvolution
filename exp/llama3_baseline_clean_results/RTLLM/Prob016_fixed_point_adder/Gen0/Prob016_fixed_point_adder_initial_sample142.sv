module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign, absolute value addition
        res = a + b;
        if (res[N] == 1'b1) begin // Overflow, adjust result
            res = {1'b0, res[N-1:1]};
        end
    end else begin // Different signs, absolute value subtraction
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a > (~b + 1'b1)) begin // a is greater than b
                res = a - (~b + 1'b1);
                res[N-1:0] = res[N-1:0]; // Result is positive
            end else begin
                res = (~b + 1'b1) - a;
                res[N-1] = 1'b1; // Result is negative
                res[N-2:0] = res[N-2:0];
            end
        end else begin // a is negative, b is positive
            if ((~a + 1'b1) > b) begin // a is greater than b (in absolute value)
                res = (~a + 1'b1) - b;
                res[N-1] = 1'b1; // Result is negative
                res[N-2:0] = res[N-2:0];
            end else begin
                res = b - (~a + 1'b1);
                res[N-1:0] = res[N-1:0]; // Result is positive
            end
        end
    end
    c = res;
end

endmodule