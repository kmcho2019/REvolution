module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        // Absolute value addition
        res = a + b;
    end else begin // Different signs
        if (a[N-1] == 0) begin // a is positive
            if (a > (~b + 1)) begin // a is greater than b
                res = a - (~b + 1); // a - b
            end else begin
                res = (~b + 1) - a; // b - a
                res = ~res + 1; // Two's complement for negative result
            end
        end else begin // a is negative
            if ((~a + 1) > b) begin // a is greater than b (in absolute value)
                res = (~a + 1) - b; // a - b
                res = ~res + 1; // Two's complement for negative result
            end else begin
                res = b - (~a + 1); // b - a
            end
        end
    end
    c = res; // Assign the result to output
end

endmodule