module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 0) begin  // 'a' is positive, 'b' is negative
            if (a > (~b + 1)) begin  // Compare absolute values
                res = a + (~b + 1);  // 'a' is greater, result is positive
            end else begin
                res = (~b + 1) - a;  // 'b' is greater, result is negative
                res = ~res + 1;  // Convert to two's complement
            end
        end else begin  // 'a' is negative, 'b' is positive
            if ((~a + 1) > b) begin  // Compare absolute values
                res = (~a + 1) + b;  // 'a' is greater, result is negative
                res = ~res + 1;  // Convert to two's complement
            end else begin
                res = b - (~a + 1);  // 'b' is greater, result is positive
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        res = {1'b0, {N-1{1'b0}}};  // Set sign bit to 0
    end

    c = res;
end

endmodule