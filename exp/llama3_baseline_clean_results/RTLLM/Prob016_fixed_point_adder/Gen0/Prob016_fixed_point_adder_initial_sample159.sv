module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, perform addition
        res = a + b;
    end else begin  // Different signs, determine larger absolute value and perform subtraction
        if (a[N-1] == 0) begin  // a is positive
            if (a >= ~b + 1) begin  // a is larger
                res = a - (~b + 1);
            end else begin  // b is larger
                res = (~b + 1) - a;
                res = ~res + 1;  // Two's complement to handle negative result
            end
        end else begin  // a is negative
            if (~a + 1 >= b) begin  // a is larger (in absolute value)
                res = (~a + 1) - b;
                res = ~res + 1;  // Two's complement to handle negative result
            end else begin  // b is larger
                res = b - (~a + 1);
            end
        end
    end

    // Check for overflow and adjust if necessary
    if (res >= (1 << (N-1))) begin
        res = {1'b1, {N-1{1'b0}}};  // Overflow, set to max value
    end else if (res < -(1 << (N-1))) begin
        res = {1'b1, {N-1{1'b1}}};  // Underflow, set to min value
    end
end

assign c = res;

endmodule