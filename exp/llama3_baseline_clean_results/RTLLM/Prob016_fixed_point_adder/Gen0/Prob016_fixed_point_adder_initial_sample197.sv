module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Determine the sign bits of the input operands
    logic sign_a = a[N-1];
    logic sign_b = b[N-1];

    // Perform addition or subtraction based on the signs
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1:Q] > b[N-1:Q]) begin
            // a is greater than b
            res = a - b;
        end else if (b[N-1:Q] > a[N-1:Q]) begin
            // b is greater than a
            res = b - a;
        end else begin
            // a and b have the same absolute value
            res = 0;
        end
    end

    // Handle potential overflows
    if (res[N-1]!= res[N-2]) begin
        // Overflow occurred, handle it by saturating the result
        if (res[N-1]) begin
            res = {1'b1, {N-1{1'b1}}};
        end else begin
            res = {1'b0, {N-1{1'b0}}};
        end
    end
end

assign c = res;

endmodule