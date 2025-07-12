module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
        if (a >= -b) begin
            res = a + (~b + 1'b1);  // Add absolute values
        end else begin
            res = (~a + 1'b1) + b;  // Add absolute values and negate result
            res = ~res + 1'b1;  // Two's complement to get negative result
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a is negative, b is positive
        if (-a >= b) begin
            res = (~a + 1'b1) + b;  // Add absolute values and negate result
            res = ~res + 1'b1;  // Two's complement to get negative result
        end else begin
            res = a + (~b + 1'b1);  // Add absolute values
        end
    end

    if (res == 0) begin  // Handle zero result
        res = {1'b0, {N-1{1'b0}}};
    end
end

assign c = res;

endmodule