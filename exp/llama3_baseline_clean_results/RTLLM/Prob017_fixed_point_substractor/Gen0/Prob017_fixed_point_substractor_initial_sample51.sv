module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits (integer and fractional)
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 0 && b[N-1] == 1) begin // a is positive, b is negative
        if (a >= (~b + 1)) begin // a is greater than or equal to the absolute value of b
            res = a + (~b + 1); // Add absolute values and set sign to positive
        end else begin
            res = (~b + 1) - a; // Add absolute values and set sign to negative
            res = ~res + 1; // Two's complement to handle negative result
        end
    end else if (a[N-1] == 1 && b[N-1] == 0) begin // a is negative, b is positive
        if ((~a + 1) >= b) begin // Absolute value of a is greater than or equal to b
            res = (~a + 1) + b; // Add absolute values and set sign to negative
            res = ~res + 1; // Two's complement to handle negative result
        end else begin
            res = b - (~a + 1); // Add absolute values and set sign to positive
        end
    end
    
    if (res == 0) begin // Explicitly handle the case when the result is zero
        c = 0;
    end else begin
        c = res;
    end
end

endmodule