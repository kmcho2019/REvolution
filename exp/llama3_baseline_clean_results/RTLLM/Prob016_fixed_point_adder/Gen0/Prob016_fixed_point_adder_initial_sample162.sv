module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,  // First N-bit fixed-point input operand
    input [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c  // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign bits, perform absolute value addition
        res = a + b;
    end else begin  // Different sign bits, perform absolute value subtraction
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a > b) begin
                res = a - b;
            end else begin
                res = b - a;
                // Set MSB of result to 1 (negative) if result is not zero
                if (res!= 0) begin
                    res[N-1] = 1'b1;
                end
            end
        end else begin  // a is negative, b is positive
            if (b > a) begin
                res = b - a;
            end else begin
                res = a - b;
                // Set MSB of result to 1 (negative) if result is not zero
                if (res!= 0) begin
                    res[N-1] = 1'b1;
                end
            end
        end
    end
end

assign c = res;

endmodule