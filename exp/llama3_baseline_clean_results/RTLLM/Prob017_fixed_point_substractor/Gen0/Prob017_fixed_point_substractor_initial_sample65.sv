module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(a, b) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different sign
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
            res = a + (~b + 1'b1);
            if (a >= (~b + 1'b1)) begin
                res[N-1] = 1'b0; // Result is positive
            end else begin
                res[N-1] = 1'b1; // Result is negative
            end
        end else begin // a is negative, b is positive
            res = (~a + 1'b1) + b;
            if ((~a + 1'b1) >= b) begin
                res[N-1] = 1'b1; // Result is negative
            end else begin
                res[N-1] = 1'b0; // Result is positive
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