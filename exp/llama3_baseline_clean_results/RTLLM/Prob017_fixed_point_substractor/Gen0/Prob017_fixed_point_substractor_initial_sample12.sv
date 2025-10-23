module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result
);

reg [N-1:0] res;  // Internal N-bit register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
    end else begin  // Different signs
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a >= ~b + 1) begin
                res = a + ~b + 1;  // a is greater, result is positive
            end else begin
                res = ~b + 1 - a;  // a is smaller, result is negative
            end
        end else begin  // a is negative, b is positive
            if (~a + 1 >= b) begin
                res = ~a + 1 - b;  // a is greater (in absolute value), result is negative
            end else begin
                res = b - (~a + 1);  // a is smaller (in absolute value), result is positive
            end
        end
    end
    
    // Handle zero result case
    if (res == 0) begin
        c[N-1] = 0;  // Explicitly set sign bit to 0 for zero result
        c[N-2:0] = 0;
    end else begin
        c = res;
    end
end

endmodule