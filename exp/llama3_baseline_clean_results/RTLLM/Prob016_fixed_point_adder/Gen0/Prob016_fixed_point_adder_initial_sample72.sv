module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   wire [N-1:0] a,
    input   wire [N-1:0] b,
    output  wire [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Check if the signs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // If signs are the same, perform addition
        res = a + b;
    end else begin
        // If signs are different, perform subtraction
        if (a[N-1] == 1) begin  // a is negative
            if (b[N-1] == 0) begin  // b is positive
                // Subtract b from a (considering two's complement)
                res = a - (b + 1'b1);
            end else begin
                // Both a and b are negative, subtract b from a
                res = a - b;
            end
        end else begin  // a is positive
            if (b[N-1] == 1) begin  // b is negative
                // Subtract a from b (considering two's complement)
                res = b - (a + 1'b1);
            end else begin
                // Both a and b are positive, subtract b from a
                res = a - b;
            end
        end
    end

    // Handle overflow by ensuring the result fits within the N-bit range
    if (res[N] == 1'b1) begin
        // If MSB is 1, it indicates overflow; manage it according to the sign bit
        if (a[N-1] == 1'b1) begin  // Negative overflow
            res = {N{1'b1}};
        end else begin  // Positive overflow
            res = {N{1'b0}};
        end
    end
end

assign c = res;

endmodule