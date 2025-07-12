module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits (integer + fractional)
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 1'b0) begin  // a is positive, b is negative
            res = a + (~b + 1'b1);  // Add absolute values
            if (res[N-1] == 1'b1) begin  // Result is negative
                res = ~res + 1'b1;  // Convert to two's complement
            end
        end else begin  // a is negative, b is positive
            res = (~a + 1'b1) + b;  // Add absolute values
            if (res[N-1] == 1'b0) begin  // Result is positive
                // No need to do anything, result is already in two's complement
            end else begin  // Result is negative
                res = ~res + 1'b1;  // Convert to two's complement
            end
        end
    end

    if (res == 0) begin  // Handle zero result
        res = 0;
    end
end

assign c = res;

endmodule