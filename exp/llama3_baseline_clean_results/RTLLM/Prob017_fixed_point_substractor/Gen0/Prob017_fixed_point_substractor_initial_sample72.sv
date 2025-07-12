module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
        if (res == 0) begin
            res[N-1] = 0;  // Handle zero result
        end
    end else begin  // Different sign subtraction
        if (a[N-1] == 0) begin  // a is positive, b is negative
            res = a + (~b + 1);  // Add absolute values
            if (a >= (~b + 1)) begin
                res[N-1] = 0;  // Positive result
            end else begin
                res[N-1] = 1;  // Negative result
            end
        end else begin  // a is negative, b is positive
            res = (~a + 1) + b;  // Add absolute values
            if ((~a + 1) >= b) begin
                res[N-1] = 1;  // Negative result
            end else begin
                res[N-1] = 0;  // Positive result
            end
        end
        if (res == 0) begin
            res[N-1] = 0;  // Handle zero result
        end
    end
end

assign c = res;

endmodule