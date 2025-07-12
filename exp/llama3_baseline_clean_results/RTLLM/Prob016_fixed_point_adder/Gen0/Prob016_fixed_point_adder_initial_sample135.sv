module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // MSBs are the same (both positive or both negative)
        res = a + b;  // Absolute value addition
    end else begin  // MSBs are different (one positive, one negative)
        if (a[N-1] == 0 && b[N-1] == 1) begin  // a is positive, b is negative
            res = a - (~b + 1);  // a - b
        end else begin  // a is negative, b is positive
            res = (~a + 1) - b;  // b - a
        end
    end
    
    // Handle overflow by checking the MSB
    if (res[N] == 1) begin
        if (a[N-1] == 0) begin  // Result should be positive
            res = {1'b0, {N-1{1'b1}}};  // Saturate to max positive value
        end else begin  // Result should be negative
            res = {1'b1, {N-1{1'b0}}};  // Saturate to min negative value
        end
    end
    
    c = res;  // Assign result to output
end

endmodule