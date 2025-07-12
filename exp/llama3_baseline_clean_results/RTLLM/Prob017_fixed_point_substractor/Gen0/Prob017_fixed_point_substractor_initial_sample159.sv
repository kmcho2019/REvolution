module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits (integer + fractional)
) (
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res; // N-bit register used to store the result of the subtraction operation

always @(a or b) begin
    // Check if both inputs have the same sign
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        // Same sign subtraction: subtract the fractional and integer parts
        res = a - b;
    end else begin
        // Different sign subtraction: add the absolute values of 'a' and 'b'
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // 'a' is positive and 'b' is negative
            if (a >= ~b + 1) begin
                // 'a' is greater than 'b'
                res = a + ~b + 1;
            end else begin
                // 'b' is greater than 'a'
                res = ~b + 1 - a;
                res[N-1] = 1'b1; // Set the sign bit to 1 (negative)
            end
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            // 'a' is negative and 'b' is positive
            if (~a + 1 >= b) begin
                // 'a' is greater than 'b'
                res = ~a + 1 + b;
                res[N-1] = 1'b1; // Set the sign bit to 1 (negative)
            end else begin
                // 'b' is greater than 'a'
                res = b - (~a + 1);
            end
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        c[N-1] = 1'b0; // Set the sign bit to 0 (positive)
        c[N-2:0] = 0;  // Set the remaining bits to 0
    end else begin
        c = res;
    end
end

endmodule