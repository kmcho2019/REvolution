module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // Internal register to store the result

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Both positive or both negative
        // Absolute value addition
        res = a + b;
        if (res >= (1 << N)) begin  // Overflow handling
            res = {1'b1, {N-1{1'b0}}};  // Set MSB and clear other bits on overflow
        end
    end else begin  // Different signs, perform subtraction
        if (a >= b) begin  // a is greater than b
            res = a - b;
        end else begin  // b is greater than a
            res = b - a;
        end
        // No need for explicit overflow handling here, as the result of subtraction
        // will inherently fit within the N-bit range or will be zero.
    end
    c = res;  // Assign the result to the output
end

endmodule