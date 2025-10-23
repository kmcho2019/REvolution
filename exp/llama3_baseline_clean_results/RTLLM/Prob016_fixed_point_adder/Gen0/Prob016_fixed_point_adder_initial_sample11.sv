module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a, // First fixed-point input operand
    input   [N-1:0] b, // Second fixed-point input operand
    output  [N-1:0] c  // Output representing the result of the fixed-point addition
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // If both inputs have the same sign
        res = a + b; // Add their absolute values
    end else begin // If inputs have different signs
        if (a[N-1] == 1'b0) begin // 'a' is positive
            if (a >= (~b + 1'b1)) begin // If absolute value of 'a' is larger
                res = a - (~b + 1'b1); // 'a' - 'b', result is positive
                res[N-1] = 1'b0; // Ensure result is positive
            end else begin // If absolute value of 'b' is larger
                res = (~b + 1'b1) - a; // 'b' - 'a', determine sign based on result
            end
        end else begin // 'a' is negative
            if ((~a + 1'b1) >= b) begin // If absolute value of 'a' is larger
                res = (~a + 1'b1) - b; // 'a' - 'b', determine sign based on result
            end else begin // If absolute value of 'b' is larger
                res = b - (~a + 1'b1); // 'b' - 'a', result is positive
                res[N-1] = 1'b0; // Ensure result is positive
            end
        end
    end
    c = res; // Assign result to output
end

endmodule