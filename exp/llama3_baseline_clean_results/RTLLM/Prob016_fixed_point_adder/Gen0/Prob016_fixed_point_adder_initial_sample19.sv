module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits
)
(
    input  [N-1:0] a, // First N-bit fixed-point input operand
    input  [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result
);

reg [N-1:0] res; // N-bit register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same signs, add absolute values
        if (a[N-1] == 1'b0) begin // Both positive
            res = a + b;
        end else begin // Both negative
            res = -(-a + (-b)); // Two's complement
        end
    end else begin // Different signs, subtract absolute values
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a >= -b) begin // a is larger
                res = a + (-b); // Two's complement
            end else begin // b is larger
                res = -(-b + (-a)); // Two's complement
            end
        end else begin // a is negative, b is positive
            if (-a >= b) begin // a is larger (in absolute value)
                res = -(-a + (-b)); // Two's complement
            end else begin // b is larger
                res = b + (-a); // Two's complement
            end
        end
    end
    
    // Overflow handling (if result exceeds N-bit range)
    if (res[N-1]!= res[N-2]) begin // Sign bit different from next bit
        if (res[N-1] == 1'b0) begin // Positive overflow
            res = {1'b0, {N-1{1'b1}}}; // Saturate at max positive value
        end else begin // Negative overflow
            res = {1'b1, {N-1{1'b0}}}; // Saturate at min negative value
        end
    end
end

assign c = res;

endmodule