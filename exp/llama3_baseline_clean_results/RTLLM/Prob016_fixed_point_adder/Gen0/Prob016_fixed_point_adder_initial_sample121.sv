module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        // Absolute value addition
        res = a + b;
    end else begin  // Different signs
        if (a[N-1] == 0) begin  // a is positive
            if (a > ~b + 1) begin  // a is greater
                res = a - (~b + 1);
            end else begin  // b is greater
                res = (~a + 1) - b;
                res = ~(res - 1);  // Two's complement for negative result
            end
        end else begin  // a is negative
            if (~a + 1 > b) begin  // a is greater in absolute value
                res = (~a + 1) - b;
                res = ~(res - 1);  // Two's complement for negative result
            end else begin  // b is greater
                res = b - (~a + 1);
            end
        end
    end
end

assign c = res;

endmodule