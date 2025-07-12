module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register to store the result

always @(a or b) begin
    // Determine the signs of the input operands
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        if (a[N-1] == 0) begin
            // Both positive
            res = a + b;
        end else begin
            // Both negative
            res = -a + (-b);
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 0) begin
            // a is positive, b is negative
            if (a > -b) begin
                res = a + b;
            end else begin
                res = b + a;
            end
        end else begin
            // a is negative, b is positive
            if (-a > b) begin
                res = -a + (-b);
            end else begin
                res = b + a;
            end
        end
    end
    
    // Handle overflow
    if (res >= (1 << N)) begin
        res = (1 << N) - 1;
    end else if (res < -(1 << N)) begin
        res = -(1 << N);
    end
end

assign c = res;

endmodule