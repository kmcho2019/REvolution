module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits
)(
    input   wire [N-1:0] a, // First N-bit fixed-point input operand
    input   wire [N-1:0] b, // Second N-bit fixed-point input operand
    output  wire [N-1:0] c  // N-bit output representing the result
);

reg [N-1:0] res; // N-bit register to store the result

always @(a, b) begin
    if (a[N-1] == b[N-1]) begin // Same sign, absolute value addition
        if (a[N-1] == 1'b0) begin // Both positive
            res = a + b;
            if (res >= (1 << N)) begin // Overflow handling
                res = {1'b1, {(N-1){1'b1}}};
            end
        end else begin // Both negative
            res = -a + (-b);
            if (res <= -((1 << N) - 1)) begin // Underflow handling
                res = {1'b1, {(N-1){1'b1}}};
            end
        end
    end else begin // Different signs, absolute value subtraction
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a >= -b) begin
                res = a + (-b); // a - b
                if (res < 0) begin // Result is negative
                    res = -res; // Take two's complement
                end else begin
                    res = {1'b0, {N-1{1'b0}}}; // Positive result, zero extend
                end
            end else begin
                res = (-b) + a; // b - a
                res = -res; // Take two's complement for negative result
            end
        end else begin // a is negative, b is positive
            if (b >= -a) begin
                res = b + (-a); // b - a
            end else begin
                res = (-a) + b; // a - b
                res = -res; // Take two's complement for negative result
            end
        end
    end
end

assign c = res;

endmodule