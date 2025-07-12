module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

    reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

    always @(*) begin
        // Check if the most significant bits (MSBs) of `a` and `b` are the same (both positive or both negative)
        if (a[N-1] == b[N-1]) begin
            // Absolute Value Addition: Add the absolute values of `a` and `b`
            res = a + b;
        end else begin
            // Absolute Value Subtraction: Determine the larger absolute value
            if (a[N-1] == 1 && b[N-1] == 0) begin
                // `a` is negative and `b` is positive
                if (a < b) begin
                    // `b` is greater than `a`, result is `b - a` and MSB of the result is 0 (positive)
                    res = b - (a[N-1] ? -a : a);
                end else begin
                    // `a` is greater than `b`, result is `a - b` and MSB of the result is 1 (negative)
                    res = (a[N-1] ? -a : a) - b;
                end
            end else begin
                // `a` is positive and `b` is negative
                if (a < b) begin
                    // `b` is greater than `a`, result is `b - a` and MSB of the result is 1 (negative)
                    res = (b[N-1] ? -b : b) - a;
                end else begin
                    // `a` is greater than `b`, result is `a - b` and MSB of the result is 0 (positive)
                    res = a - (b[N-1] ? -b : b);
                end
            end
        end
        // Ensure the result fits within the N-bit range (overflow handling)
        if (res >= (1 << N)) begin
            res = (1 << N) - 1;
        end else if (res < 0) begin
            res = 0;
        end
    end

    // Assign the result to the output port
    assign c = res;

endmodule