module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Check if 'a' and 'b' have the same sign
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        res = a - b;
        // Handle the case when the result is zero
        if (res == 0) begin
            c = 0;
        end else begin
            c = res;
        end
    end else begin
        // Different sign subtraction
        if (a[N-1] == 1) begin // 'a' is negative
            if (b[N-1] == 0) begin // 'b' is positive
                if (a < b) begin
                    // 'b' is greater than 'a', result is positive
                    res = b - (a + (1 << (N-1)));
                end else begin
                    // 'a' is greater than 'b', result is negative
                    res = (a + (1 << (N-1))) - b;
                end
            end
        end else begin // 'a' is positive
            if (b[N-1] == 1) begin // 'b' is negative
                if (a < (b + (1 << (N-1)))) begin
                    // 'b' is greater than 'a', result is negative
                    res = (b + (1 << (N-1))) - a;
                end else begin
                    // 'a' is greater than 'b', result is positive
                    res = a - (b + (1 << (N-1)));
                end
            end
        end
        // Handle the case when the result is zero
        if (res == 0) begin
            c = 0;
        end else begin
            c = res;
        end
    end
end

endmodule