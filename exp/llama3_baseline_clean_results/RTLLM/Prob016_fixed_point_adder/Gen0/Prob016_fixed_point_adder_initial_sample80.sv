module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

    // Internal register to store the result
    reg [N-1:0] res;

    // Determine the sign bits of the input operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Determine if the operation is addition or subtraction
    wire add_op = sign_a == sign_b;

    // Calculate the absolute values of the operands
    wire [N-1:0] abs_a = sign_a ? (~a + 1) : a;
    wire [N-1:0] abs_b = sign_b ? (~b + 1) : b;

    // Perform the operation
    always @(*) begin
        if (add_op) begin
            // If signs are the same, add the absolute values
            res = abs_a + abs_b;
            // If the result overflows, set the most significant bit
            if (res[N-1] != sign_a && res[N] == 1) begin
                res[N-1] = sign_a;
            end
        end else begin
            // If signs are different, perform subtraction
            if (abs_a > abs_b) begin
                // a is greater than b, result is a - b
                res = abs_a - abs_b;
                // Set the most significant bit to 0 (positive)
                res[N-1] = 0;
            end else begin
                // b is greater than a, result is b - a
                res = abs_b - abs_a;
                // Set the most significant bit to 1 (negative) if result is not zero
                if (res != 0) begin
                    res[N-1] = 1;
                end
            end
        end
    end

    // Assign the result to the output
    assign c = res;

endmodule