module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res; // N-bit register used to store the result of the addition or subtraction

always @(*) begin
    // Check if the MSBs of a and b are the same
    if (a[N-1] == b[N-1]) begin
        // Add absolute values and set MSB of result
        res = (a[N-1] == 1'b0)? (a + b) : -(~a + 1) + -(~b + 1);
    end else begin
        // Perform subtraction
        if ((a[N-1] == 1'b0 && a > (~b + 1)) || (a[N-1] == 1'b1 && -(~a + 1) > b)) begin
            // a is greater than b
            res = a - (a[N-1] == 1'b0)? b : -(~b + 1);
        end else begin
            // b is greater than a
            res = b - (b[N-1] == 1'b0)? a : -(~a + 1);
        end
    end

    // Check for overflow
    if (res[N-1]!= res[N-2]) begin
        // Handle overflow
        if (res[N-1] == 1'b0) begin
            // Positive overflow
            res = {1'b0, {N-1{1'b1}}};
        end else begin
            // Negative overflow
            res = {1'b1, {N-1{1'b0}}};
        end
    end

    // Assign output
    c = res;
end

endmodule