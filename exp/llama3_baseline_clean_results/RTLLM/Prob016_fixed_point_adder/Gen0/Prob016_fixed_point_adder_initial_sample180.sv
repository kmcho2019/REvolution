module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // If the MSBs of a and b are the same
        res = a + b;  // Perform absolute value addition
    end else begin
        if (a[N-1] == 1'b0) begin  // If a is positive
            if (b[N-1] == 1'b1) begin  // If b is negative
                if (a > ~b + 1) begin  // If a is greater than b
                    res = a - (~b + 1);  // Result is a - b
                    res[N-1] = 1'b0;  // Set MSB to 0 (positive)
                end else begin
                    res = (~a + 1) - b;  // Result is b - a
                    if (res == 0) begin
                        res[N-1] = 1'b0;  // Set MSB to 0 if result is zero
                    end else begin
                        res[N-1] = 1'b1;  // Set MSB to 1 if result is negative
                    end
                end
            end
        end else begin
            if (b[N-1] == 1'b0) begin  // If b is positive
                if (b > ~a + 1) begin  // If b is greater than a
                    res = b - (~a + 1);  // Result is b - a
                    res[N-1] = 1'b0;  // Set MSB to 0 (positive)
                end else begin
                    res = (~b + 1) - a;  // Result is a - b
                    if (res == 0) begin
                        res[N-1] = 1'b0;  // Set MSB to 0 if result is zero
                    end else begin
                        res[N-1] = 1'b1;  // Set MSB to 1 if result is negative
                    end
                end
            end
        end
    end
    c = res;  // Assign the result to output c
end

endmodule