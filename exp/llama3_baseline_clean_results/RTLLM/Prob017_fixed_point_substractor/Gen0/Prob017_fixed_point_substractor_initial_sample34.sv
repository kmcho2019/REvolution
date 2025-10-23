module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
) (
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c  // N-bit output representing the result
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    // Check if the signs of a and b are the same
    if ((a[N-1] == 1) && (b[N-1] == 1)) begin  // Both a and b are negative
        // Subtract b from a (keeping the same sign)
        res = a - b;
    end else if ((a[N-1] == 0) && (b[N-1] == 0)) begin  // Both a and b are positive
        // Subtract b from a (keeping the same sign)
        res = a - b;
    end else if ((a[N-1] == 0) && (b[N-1] == 1)) begin  // a is positive, b is negative
        // Add the absolute values of a and b
        res = a + (~b + 1);  // Perform two's complement addition
    end else begin  // a is negative, b is positive
        // Add the absolute values of a and b
        res = (~a + 1) + b;  // Perform two's complement addition
    end

    // Handle the zero result edge case
    if (res == 0) begin
        res[N-1] = 0;  // Explicitly set the sign bit to 0
    end
end

assign c = res;  // Assign the result to the output port

endmodule