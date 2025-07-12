module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
) (
    input   wire [N-1:0] a,  // First N-bit fixed-point input operand
    input   wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output  wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, absolute value addition
        res = a + b;
    end else begin  // Different signs, absolute value subtraction
        if (a[N-1] == 1) begin  // a is negative
            if (a < b) begin
                res = b - a;
                res[N-1] = 0;  // Result is positive
            end else begin
                res = a - b;
                res[N-1] = 1;  // Result is negative
            end
        end else begin  // b is negative
            if (b < a) begin
                res = a - b;
                res[N-1] = 0;  // Result is positive
            end else begin
                res = b - a;
                res[N-1] = 1;  // Result is negative
            end
        end
    end
    
    // Handle overflow
    if (res >= (1 << N)) begin
        res = (1 << N) - 1;  // Saturate the result
    end else if (res < -(1 << N)) begin
        res = -(1 << N);  // Saturate the result
    end
end

assign c = res;

endmodule