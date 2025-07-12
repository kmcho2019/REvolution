module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32 // Total number of bits (both integer and fractional)
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        if (a[N-1] == 1'b0) begin // Both positive
            res = a - b;
        end else begin // Both negative
            res = -b - (-a);
        end
    end else begin // Different signs
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a >= -b) begin
                res = a + (-b);
            end else begin
                res = -( -b - a);
            end
        end else begin // a is negative, b is positive
            if (-a >= b) begin
                res = -( -a - b);
            end else begin
                res = b - (-a);
            end
        end
    end
    
    if (res == 0) begin // Handle zero result
        res = 0;
    end
end

assign c = res;

endmodule