module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Check if both numbers have the same sign
    if (a[N-1] == b[N-1]) begin
        // Add absolute values if signs are the same
        res = a + b;
    end else begin
        // Determine larger absolute value if signs are different
        if (a[N-1] == 0) begin // a is positive
            if (a > (~b + 1)) begin // Two's complement of b
                res = a - (~b + 1); // a - b
            end else begin
                res = (~b + 1) - a; // b - a
                // Set MSB to 1 if result is negative (which means b was larger)
                res[N-1] = 1;
            end
        end else begin // a is negative
            if ((~a + 1) > b) begin // Two's complement of a
                res = (~a + 1) - b; // b - a
            end else begin
                res = b - (~a + 1); // a - b
                // Set MSB to 0 if result is positive (which means b was larger)
                res[N-1] = 0;
            end
        end
    end
    
    // Assign result to output
    c = res;
end

endmodule