module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input [N-1:0] a, 
    input [N-1:0] b, 
    output [N-1:0] c
);

reg [N-1:0] res;

// Perform subtraction based on the signs of a and b
always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign
        res = a - b;
    end else begin // Different signs
        if (a[N-1] == 0) begin // a is positive, b is negative
            if (a > -b) begin // a is greater than b
                res = a + (~b + 1); // Add a and the two's complement of b
            end else begin
                res = (~a + 1) + b; // Subtract a from b and negate the result
                res = ~res + 1; // Get the two's complement of the result
            end
        end else begin // a is negative, b is positive
            if (-a > b) begin // a is greater than b in magnitude
                res = (~a + 1) + (~b + 1); // Add the two's complements of a and b
            end else begin
                res = b + (~a + 1); // Subtract a from b
            end
        end
    end

    // Handle zero result
    if (res == 0) begin
        c = 0;
    end else begin
        c = res;
    end
end

endmodule