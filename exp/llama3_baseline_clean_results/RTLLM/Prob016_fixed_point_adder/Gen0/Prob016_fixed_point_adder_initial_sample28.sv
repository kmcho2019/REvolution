module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // Internal N-bit register to store the result

always @(*) begin
    // Determine the sign of the inputs
    if (a[N-1] == b[N-1]) begin
        // Same signs, absolute value addition
        res = a + b;
    end else begin
        // Different signs, absolute value subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a > (~b + 1)) begin
                // a is greater, result is a - b
                res = a + (~b + 1);
            end else begin
                // b is greater, result is b - a
                res = (~a + 1) + b;
            end
        end else begin
            // a is negative, b is positive
            if ((~a + 1) > b) begin
                // a is greater, result is a - b
                res = (~a + 1) + (~b + 1);
            end else begin
                // b is greater, result is b - a
                res = b + (~a + 1);
            end
        end
    end

    // Assign the result to the output, handling overflow
    if (res[N-1] != res[N-2]) begin
        // Overflow occurred, set MSB to match the sign of the result
        c = {N{res[N-1]}};
    end else begin
        c = res;
    end
end

endmodule