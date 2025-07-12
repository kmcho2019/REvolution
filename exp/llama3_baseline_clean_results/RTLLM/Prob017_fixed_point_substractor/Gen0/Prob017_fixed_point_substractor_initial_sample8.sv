module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Determine the signs of the inputs
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both inputs are positive
        // Perform subtraction
        res = a - b;
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both inputs are negative
        // Perform subtraction
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
        // Perform addition
        if (a >= (~b + 1)) begin
            // a is greater than or equal to b, result is positive
            res = a + (~b + 1);
        end else begin
            // a is less than b, result is negative
            res = (~b + 1) - a;
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a is negative, b is positive
        // Perform addition
        if ((~a + 1) >= b) begin
            // a is greater than or equal to b, result is negative
            res = (~a + 1) - b;
        end else begin
            // a is less than b, result is positive
            res = b - (~a + 1);
        end
    end

    // Handle the edge case where the result is zero
    if (res == 0) begin
        c = {N{1'b0}};
    end else begin
        c = res;
    end
end

endmodule